<%@ page import="java.util.Map" %>
<%@ page import="java.util.Set" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%
    String basePath = request.getScheme() + "://" + request.getServerName() + ":" + request.getServerPort() + request.getContextPath() + "/";
//取得阶段和可能性之间的对应关系pMap，后面的遍历要使用，肯定是要定义获取到元素的好吗，傻瓜
    Map<String,String> pMap = (Map<String,String>)application.getAttribute("pMap");

    Set<String> set = pMap.keySet();
%>
<html>
<head>
    <base href="<%=basePath%>">
    <meta charset="UTF-8">

    <link href="jquery/bootstrap_3.3.0/css/bootstrap.min.css" type="text/css" rel="stylesheet" />
    <link href="jquery/bootstrap-datetimepicker-master/css/bootstrap-datetimepicker.min.css" type="text/css" rel="stylesheet" />

    <script type="text/javascript" src="jquery/jquery-1.11.1-min.js"></script>
    <script type="text/javascript" src="jquery/bootstrap_3.3.0/js/bootstrap.min.js"></script>
    <script type="text/javascript" src="jquery/bootstrap-datetimepicker-master/js/bootstrap-datetimepicker.js"></script>
    <script type="text/javascript" src="jquery/bootstrap-datetimepicker-master/locale/bootstrap-datetimepicker.zh-CN.js"></script>

    <script src="jquery/bs_typeahead/bootstrap3-typeahead.min.js"></script>

    <script>
    var json = {
            <%
            for (String stage : set){
                String possibility = pMap.get(stage);
            %>
            "<%=stage%>" : "<%=possibility%>",/*woc woc woc woc woc 少了“，”，以后不要先随便定义东西，按步骤把事件处理先，不然后面都测不了！！！！*/
            <%
                }

            %>
        }
        $(function () {
            flush();
            $(".time").datetimepicker({
                minView: "month",
                language:  'zh-CN',
                format: 'yyyy-mm-dd',
                autoclose: true,
                todayBtn: true,
                pickerPosition: "bottom-left"
            });
            //加载隐藏域初始值
            function flush(){
              $.ajax({

                    url : "workbench/transaction/getHidden.do",
                    data : {
                        "id":"${t.id}"
                    },
                    type : "get",
                    dataType : "json",
                    success : function (data) {
                        $("#customerId").val(data.customerId)
                        $("#contactsId").val(data.contactsId)
                        $("#activityId").val(data.activityId)
                    }

                })
                //alert("111")
            }
            //自动补全查询
            $("#edit-customerName").typeahead({
                source:function (query,process) {
                    $.getJSON(
                        "workbench/transaction/getCustomerNameList.do",
                        {"name":query},
                        function (data) {
                            //process(data)
                            //data:用户list，要取每项id，肯定要在遍历里面啊，SB
                            var res = [];
                            $.each(data, function (i, item) {
                                //res数组中存放的是每个item是map，所以取值方式是item.key
                                var aItem = { id: item.id, name: item.name,text:item.name/*+' - '+item.id*/ };//把后台传回来的数据处理成带name形式
                                res.push(aItem);
                            })
                            return process(res);

                        }
                    )
                },
                displayText: function (item) {//item对象
                    return item.text;//下拉显示维护好的为姓名+ID
                },
                updater: function (item) {//item是对象,选中后默认返回displayText的值,对于需要的id和name没有,所以手动赋值吧
                    $('#customerId').attr('value', item.id);//把id值放到value属性里，用于后台传递，这样就不用再设置隐藏域另外存id值
                    return item.name;//下拉框显示重写为name覆盖默认的displayText
                },
                //延迟加载
                delay:50
            })
            //先为可能性设定初值
            var initstage = $("#edit-stage").val()
            var initpossibility = json[initstage]//json字符串获得值对方法（格式）

            $("#edit-possibility").val(initpossibility);
            //为阶段下拉框绑定事件，触发可能性的填写
            $("#edit-stage").change(function () {
              //选择下拉框事情，要再一次获得选择值
                var stage = $("#edit-stage").val()
                //alert(stage)
                var possibility = json[stage]
                $("#edit-possibility").val(possibility);
            })
            //点击搜索标签，弹出模态窗口，窗口中实现查找市场活动
            $("#aname").keydown(function (event) {
                if (event.keyCode == 13){
                    var html=''
                    $.ajax({

                        url : "workbench/transaction/getActivityListByName.do",
                        data : {
                            "aname":$.trim($("#aname").val())
                        },
                        type : "get",
                        dataType : "json",
                        success : function (data) {
                            $.each(data,function (i,n) {
                                 html += '<tr>',
                                 html += '<td><input type="radio" name="xz" value="'+n.id+'"/></td>',
                                 html += '<td id="'+n.id+'">'+n.name+'</td>',
                                 html += '<td>'+n.startDate+'</td>',
                                 html += '<td>'+n.endDate+'</td>',
                                 html += '<td>'+n.owner+'</td>',
                                 html += '</tr>'
                            })
                            //这里获得的要先AJAX中放到指定位置，才算结束请求
                            $("#findActivityBody").html(html)
                        }
                    })
                    return false;
                }
            })
            //模态窗口操作
            $("#submitActivityBtn").click(function () {
                //选择项目
                var $xz = $("input[name=xz]:checked")
                //这里先获得id（从value中），方便后面定位使用！！
                var id = $xz.val()
                //将项目内容放到用户展示栏
                var name = $("#"+id).html()
                $("#activityName").val(name)
                //将标志id放到隐藏域
                $("#activityId").val(id)
                //清空窗口检索信息
                $("#aname").val('')
                $("#findActivityBody").html('')
                //关闭窗口
                $("#findMarketActivity").modal("hide")
            })
            //
            $("#cname").keydown(function (event) {
                if (event.keyCode == 13){
                    $.ajax({

                        url : "workbench/transaction/getContactListByName.do",
                        data : {
                            "cname":$.trim($("#cname").val())
                        },
                        type : "get",
                        dataType : "json",
                        success : function (data) {
                            var html = ''
                            $.each(data,function (i,n) {
                                    html += '<tr>',
                                    html += '<td><input type="radio" name="xz" value="'+n.id+'"/></td> ',
                                    html += '<td id="'+n.id+'">'+n.fullname+'</td>',
                                    html += '<td>'+n.email+'</td>',
                                    html += '<td>'+n.mphone+'</td>',
                                    html += '</tr>'
                            })
                              $("#findContactBody").html(html)
                        }
                    })
                    return false
                }

            })
            //
            $("#submitContactsBtn").click(function () {
                var $xz = $("input[name=xz]:checked")
                var id = $xz.val()
                //alert(id)
                var name = $("#"+id).html()
                $("#contactsId").val(id)
                $("#contactsName").val(name)

                $("#cname").val('')
                $("#findContactBody").html('')
                $("#findContacts").modal("hide")
            })
            //提交表单，post，肯定不行，因为打开页面是通过<%--${}--%>写死了value，WOC，居然是错误想法？？？
            //submit提交的数据是前端显示的数据！！！！！
            $("#updateBtn").click(function () {
               /*
               //下面的取法：可以获取前端界面的显示值
               var transactionName = $("#edit-transactionName").val()
                alert(transactionName)*/
               //submit也是如此
                $("#tranForm").submit();
            })
        })
    </script>
</head>
<body>

<!-- 查找市场活动 -->
<div class="modal fade" id="findMarketActivity" role="dialog">
    <div class="modal-dialog" role="document" style="width: 80%;">
        <div class="modal-content">
            <div class="modal-header">
                <button type="button" class="close" data-dismiss="modal">
                    <span aria-hidden="true">×</span>
                </button>
                <h4 class="modal-title">查找市场活动</h4>
            </div>
            <div class="modal-body">
                <div class="btn-group" style="position: relative; top: 18%; left: 8px;">
                    <form class="form-inline" role="form">
                        <div class="form-group has-feedback">
                            <input type="text" class="form-control" style="width: 300px;" id="aname" placeholder="请输入市场活动名称，支持模糊查询">
                            <span class="glyphicon glyphicon-search form-control-feedback"></span>
                        </div>
                    </form>
                </div>
                <table id="activityTable4" class="table table-hover" style="width: 900px; position: relative;top: 10px;">
                    <thead>
                    <tr style="color: #B3B3B3;">
                        <td></td>
                        <td>名称</td>
                        <td>开始日期</td>
                        <td>结束日期</td>
                        <td>所有者</td>
                    </tr>
                    </thead>
                    <tbody id="findActivityBody">
                   <%-- <tr>
                        <td><input type="radio" name="activity"/></td>
                        <td>发传单</td>
                        <td>2020-10-10</td>
                        <td>2020-10-20</td>
                        <td>zhangsan</td>
                    </tr>
                    <tr>
                        <td><input type="radio" name="activity"/></td>
                        <td>发传单</td>
                        <td>2020-10-10</td>
                        <td>2020-10-20</td>
                        <td>zhangsan</td>
                    </tr>--%>
                    </tbody>
                </table>
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-default" data-dismiss="modal">取消</button>
                <button type="button" class="btn btn-primary" id="submitActivityBtn">提交</button>
            </div>
        </div>
    </div>
</div>

<!-- 查找联系人 -->
<div class="modal fade" id="findContacts" role="dialog">
    <div class="modal-dialog" role="document" style="width: 80%;">
        <div class="modal-content">
            <div class="modal-header">
                <button type="button" class="close" data-dismiss="modal">
                    <span aria-hidden="true">×</span>
                </button>
                <h4 class="modal-title">查找联系人</h4>
            </div>
            <div class="modal-body">
                <div class="btn-group" style="position: relative; top: 18%; left: 8px;">
                    <form class="form-inline" role="form">
                        <div class="form-group has-feedback">
                            <input type="text" class="form-control" style="width: 300px;" id="cname" placeholder="请输入联系人名称，支持模糊查询">
                            <span class="glyphicon glyphicon-search form-control-feedback"></span>
                        </div>
                    </form>
                </div>
                <table id="activityTable" class="table table-hover" style="width: 900px; position: relative;top: 10px;">
                    <thead>
                    <tr style="color: #B3B3B3;">
                        <td></td>
                        <td>名称</td>
                        <td>邮箱</td>
                        <td>手机</td>
                    </tr>
                    </thead>
                    <tbody id="findContactBody">
                   <%-- <tr>
                        <td><input type="radio" name="activity"/></td>
                        <td>李四</td>
                        <td>lisi@bjpowernode.com</td>
                        <td>12345678901</td>
                    </tr>
                    <tr>
                        <td><input type="radio" name="activity"/></td>
                        <td>李四</td>
                        <td>lisi@bjpowernode.com</td>
                        <td>12345678901</td>
                    </tr>--%>
                    </tbody>
                </table>
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-default" data-dismiss="modal">取消</button>
                <button type="button" class="btn btn-primary" id="submitContactsBtn">提交</button>
            </div>
        </div>
    </div>
</div>


<div style="position:  relative; left: 30px;">
    <h3>更新交易</h3>
    <div style="position: relative; top: -40px; left: 70%;">
        <button type="button" class="btn btn-primary" id="updateBtn">更新</button>
        <button type="button" class="btn btn-default">取消</button>
    </div>
    <hr style="position: relative; top: -40px;">
</div>
<form class="form-horizontal" role="form" style="position: relative; top: -30px;" id="tranForm" action="workbench/transaction/update.do" method="post">
    <input type="hidden" name="id" value=${t.id}>
    <div class="form-group">
        <label for="edit-transactionOwner" class="col-sm-2 control-label">所有者<span style="font-size: 15px; color: red;">*</span></label>
        <div class="col-sm-10" style="width: 300px;">
            <select class="form-control" id="edit-owner" name="owner">
                <option></option>
                <c:forEach items="${userList}" var="u">
                    <option value="${u.id}" ${t.owner eq u.name ? "selected" : ""}>${u.name}</option>
                </c:forEach>
            </select>
        </div>
        <label for="edit-amountOfMoney" class="col-sm-2 control-label">金额</label>
        <div class="col-sm-10" style="width: 300px;">
            <input type="text" class="form-control" id="edit-amountOfMoney" value="5,000" name="money">
        </div>
    </div>

    <div class="form-group">
        <label for="edit-transactionName" class="col-sm-2 control-label">名称<span style="font-size: 15px; color: red;">*</span></label>
        <div class="col-sm-10" style="width: 300px;">
            <input type="text" class="form-control" id="edit-transactionName" name="name" value=${t.name}>
        </div>
        <label for="edit-expectedClosingDate" class="col-sm-2 control-label">预计成交日期<span style="font-size: 15px; color: red;">*</span></label>
        <div class="col-sm-10" style="width: 300px;">
            <input type="text" class="form-control time" id="edit-expectedClosingDate" name="expectedDate" value=${t.expectedDate}>
        </div>
    </div>

    <div class="form-group">
        <label for="edit-accountName" class="col-sm-2 control-label">客户名称<span style="font-size: 15px; color: red;">*</span></label>
        <div class="col-sm-10" style="width: 300px;">
            <input type="text" class="form-control" id="edit-customerName" value=${t.customerId} placeholder="支持自动补全，输入客户不存在则新建">
            <input type="hidden" id="customerId" name="customerId">
        </div>
        <label for="edit-transactionStage" class="col-sm-2 control-label">阶段<span style="font-size: 15px; color: red;">*</span></label>
        <div class="col-sm-10" style="width: 300px;">
            <select class="form-control" id="edit-stage" name="stage">
                <option></option>
                <c:forEach items="${stageList}" var="s">
                    <option value="${s.value}" ${s.text eq t.stage ? "selected":""}>${s.text}</option>
                </c:forEach>
            </select>
        </div>
    </div>

    <div class="form-group">
        <label for="edit-transactionType" class="col-sm-2 control-label">类型</label>
        <div class="col-sm-10" style="width: 300px;">
            <select class="form-control" id="edit-transactionType" name="type">
                <option></option>
                <c:forEach items="${transactionTypeList}" var="tran">
                    <option value="${tran.value}" ${tran.value eq t.type ?"selected":""}>${tran.text}</option>
                </c:forEach>
            </select>
        </div>
        <label for="edit-possibility" class="col-sm-2 control-label">可能性</label>
        <div class="col-sm-10" style="width: 300px;">
            <input type="text" class="form-control" id="edit-possibility" name="possibility">
        </div>
    </div>

    <div class="form-group">
        <label for="edit-clueSource" class="col-sm-2 control-label">来源</label>
        <div class="col-sm-10" style="width: 300px;">
            <select class="form-control" id="edit-clueSource" name="source">
                <option></option>
                <c:forEach items="${sourceList}" var="sour">
                    <option value="${sour.value}" ${sour.value eq t.source ?"selected":""}>${sour.text}</option>
                </c:forEach>
            </select>
        </div>
        <label for="edit-activitySrc" class="col-sm-2 control-label">市场活动源&nbsp;&nbsp;<a href="javascript:void(0);" data-toggle="modal" data-target="#findMarketActivity"><span class="glyphicon glyphicon-search"></span></a></label>
        <div class="col-sm-10" style="width: 300px;">
            <input type="text" class="form-control" id="activityName" value=${t.activityId}>
            <input type="hidden" id="activityId" name="activityId">
        </div>
    </div>

    <div class="form-group">
        <label for="edit-contactsName" class="col-sm-2 control-label">联系人名称&nbsp;&nbsp;<a href="javascript:void(0);" data-toggle="modal" data-target="#findContacts"><span class="glyphicon glyphicon-search"></span></a></label>
        <div class="col-sm-10" style="width: 300px;">
            <input type="text" class="form-control" id="contactsName" value=${t.contactsId}>
            <input type="hidden" id="contactsId" name="contactsId">
        </div>
    </div>

    <div class="form-group">
        <label for="create-describe" class="col-sm-2 control-label">描述</label>
        <div class="col-sm-10" style="width: 70%;">
            <textarea class="form-control" rows="3" id="create-describe" name="desctiption">${t.description}</textarea>
        </div>
    </div>

    <div class="form-group">
        <label for="create-contactSummary" class="col-sm-2 control-label">联系纪要</label>
        <div class="col-sm-10" style="width: 70%;">
            <textarea class="form-control" rows="3" id="create-contactSummary" name="contactSummary"></textarea>
        </div>
    </div>

    <div class="form-group">
        <label for="create-nextContactTime" class="col-sm-2 control-label">下次联系时间</label>
        <div class="col-sm-10" style="width: 300px;">
            <input type="text" class="form-control" id="create-nextContactTime" name="nextContactTime">
        </div>
    </div>

</form>
</body>
</html>
