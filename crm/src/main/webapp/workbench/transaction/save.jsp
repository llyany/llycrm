<%@ page import="java.util.Map" %>
<%@ page import="java.util.Set" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%
String basePath = request.getScheme() + "://" + request.getServerName() + ":" + request.getServerPort() + request.getContextPath() + "/";

//取得阶段和可能性之间的对应关系pMap，后面的遍历要使用，肯定是要定义获取到元素的好吗，傻瓜
	Map<String,String> pMap = (Map<String,String>)application.getAttribute("pMap");

	Set<String> set = pMap.keySet();

%>
<!DOCTYPE html>
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
//定义json，可以动态取值，另外，JSON的格式要记住{"xx":xx,"xx":xx.....}
		var json = {

			<%

				for(String stage:set){

					String possibility = pMap.get(stage);

			%>
					"<%=stage%>" : <%=possibility%>,

			<%
				}

			%>

		};

		//alert(json);//object Object

		$(function () {

			$("#create-customerName").typeahead({
				//由该函数来触发自动补全功能
				/*

					query：我们在文本框输入的关键字（我们要按照这个关键字来进行查询）
					process：执行自动补全的过程

				 */
				source: function (query, process) {
					$.get(
							"workbench/transaction/getCustomerNameList.do",
							{ "name" : query },
							function (data) {

								/*

									data
										[{客户名称1},{2},{3}...]

								 */

								//alert(data);
								//process:该方法只识别字符串数组参数，所以mapper的resultType为String
								process(data);

							},
							"json"
					);
				},
				//延迟加载的时间，单位是毫秒
				delay: 50
			});


			$(".time1").datetimepicker({
				minView: "month",
				language:  'zh-CN',
				format: 'yyyy-mm-dd',
				autoclose: true,
				todayBtn: true,
				pickerPosition: "bottom-left"
			});

			$(".time2").datetimepicker({
				minView: "month",
				language:  'zh-CN',
				format: 'yyyy-mm-dd',
				autoclose: true,
				todayBtn: true,
				pickerPosition: "top-left"
			});
			//1.模态窗口已经通过label标签设置点击弹出了
            //2.市场活动源搜素
            $("#aname").keydown(function (event) {

                if (event.keyCode == 13) {
                    //获得检索要求信息，返回检索结果

                    $.ajax({

                        url : "workbench/transaction/getActivityListByName.do",
                        data : {
                            "aname" : $.trim($("#aname").val())
                        },
                        type : "get",
                        dataType : "json",
                        success : function (data) {
                            var html = ""
                            $.each(data,function (i,n) {
                                html += '<tr>',
                                    html += '<td><input type="radio" value="'+n.id+'" name="xz"/></td>',
                                    html += '<td id = "'+n.id+'">'+n.name+'</td>',
                                    html += '<td>'+n.startDate+'</td>',
                                    html += '<td>'+n.endDate+'</td>',
                                    html += '<td>'+n.owner+'</td>',
                                    html += '</tr>'
                            })
                            $("#activitySearchBody").html(html)
                        }
                    })
                    return false

                }
            })
           //3.提交模糊查询后选择的最终结果
            $("#submitActivityBtn").click(function () {
                //定位选择框
                var $xz = $("input[name = xz]:checked")
                //获取选择项的id（使用val的话，则是使得id在value属性中）
                var id = $xz.val()
                //将id放入隐藏域
                $("#activityId").val(id);
                var name = $("#"+id).html()
                $("#activityName").val(name)

                //清空搜索出来的信息
                $("#activitySearchBody").html('')
                //清空搜索文本框中的信息
                $("#aname").val('')
                //关闭模态窗口
                $("#findMarketActivity").modal("hide")
            })


            //市场联系人检索
            $("#cname").keydown(function (event) {
                if (event.keyCode == 13) {

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
                                html += '<td><input type="radio" name="xz" value="'+n.id+'"/></td>',
                                html += '<td id="'+n.id+'">'+n.fullname+'</td>',
                                html += '<td>'+n.email+'</td>',
                                html += '<td>'+n.mphone+'</td>',
                                html += '</tr>'
                            })
                            $("#searchContactBody").html(html)
                        }
                    })
                    return false
                }
            })
            $("#submitContactBtn").click(function () {
                var $xz = $("input[name=xz]:checked")
                var id = $xz.val()
				//alert(id)

                var cname = $("#"+id).html()//定位fullname，还用到了上面获取的id，可以可以
                $("#contactsName").val(cname)

                //清空搜索出来的信息
                $("#searchContactBody").html('')
                //清空搜索文本框中的信息
                $("#cname").val('')
                //关闭模态窗口
                $("#findContacts").modal("hide");
            })

			//为阶段下拉框绑定事件，触发可能性的填写
			$("#create-stage").change(function () {

				var stage = $("#create-stage").val();

				//alert(stage);

				/*

					现在我们有了阶段stage
					阶段和可能性之间的对应关系pMap,由于pMap是java中的键值对关系，js用不了
												我们需要将pMap转换为js中的键值对关系json
												我们想要的是
												var json = {"01资质审查":10,"02需求分析":25.......}

					json拿到了
					来处理可能性


				 */

				//var possibility = json.stage;
				/*

					以上取值方式不行，因为我们的key（stage），是动态生成的变量
					如果是这种形式的key，我们就不能以传统json.key的形式来取值，我们要以json[key]

				 */
				var possibility = json[stage];
				//alert(possibility);
				//为可能性文本框赋值
				$("#create-possibility").val(possibility);

			})


			//为保存按钮绑定事件
			$("#saveBtn").click(function () {

				//提交表单
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
                              <input type="text" class="form-control" id="aname" style="width: 300px;" placeholder="请输入市场活动名称，支持模糊查询">
						    <span class="glyphicon glyphicon-search form-control-feedback"></span>
						  </div>
                        </form>
					</div>
					<table id="activityTable3" class="table table-hover" style="width: 900px; position: relative;top: 10px;">
						<thead>
							<tr style="color: #B3B3B3;">
								<td></td>
								<td>名称</td>
								<td>开始日期</td>
								<td>结束日期</td>
								<td>所有者</td>
							</tr>
						</thead>
						<tbody id="activitySearchBody">
							<%--<tr>
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
						    <input type="text" class="form-control" id="cname" style="width: 300px;" placeholder="请输入联系人名称，支持模糊查询">
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
						<tbody id="searchContactBody">
							<%--<tr>
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
                    <button type="button" class="btn btn-primary" id="submitContactBtn">提交</button>
                </div>
			</div>
		</div>
	</div>
	
	
	<div style="position:  relative; left: 30px;">
		<h3>创建交易</h3>
	  	<div style="position: relative; top: -40px; left: 70%;">
			<button type="button" class="btn btn-primary" id="saveBtn">保存</button>
			<button type="button" class="btn btn-default">取消</button>
		</div>
		<hr style="position: relative; top: -40px;">
	</div>
	<%--表单提交格式！！！！--%>
	<form id="tranForm" action="workbench/transaction/save.do" method="post" class="form-horizontal" role="form" style="position: relative; top: -30px;">
		<div class="form-group">
			<label for="create-transactionOwner" class="col-sm-2 control-label">所有者<span style="font-size: 15px; color: red;">*</span></label>
			<div class="col-sm-10" style="width: 300px;">
				<select class="form-control" id="create-transactionOwner" name="owner">
				  <option></option>
					<c:forEach items="${uList}" var="u">
						<option value="${u.id}" ${user.id eq u.id ? "selected" : ""}>${u.name}</option>
					</c:forEach>
				</select>
			</div>
			<label for="create-amountOfMoney" class="col-sm-2 control-label">金额</label>
			<div class="col-sm-10" style="width: 300px;">
				<input type="text" class="form-control" id="create-amountOfMoney" name="money">
			</div>
		</div>
		
		<div class="form-group">
			<label for="create-transactionName" class="col-sm-2 control-label">名称<span style="font-size: 15px; color: red;">*</span></label>
			<div class="col-sm-10" style="width: 300px;">
				<input type="text" class="form-control" id="create-transactionName" name="name">
			</div>
			<label for="create-expectedClosingDate" class="col-sm-2 control-label">预计成交日期<span style="font-size: 15px; color: red;">*</span></label>
			<div class="col-sm-10" style="width: 300px;">
				<input type="text" class="form-control time1" id="create-expectedClosingDate" name="expectedDate">
			</div>
		</div>
		
		<div class="form-group">
			<label for="create-accountName" class="col-sm-2 control-label">客户名称<span style="font-size: 15px; color: red;">*</span></label>
			<div class="col-sm-10" style="width: 300px;">
				<input type="text" class="form-control" id="create-customerName" name="customerName" autocomplete="off" placeholder="支持自动补全，输入客户不存在则新建">
			</div>
			<label for="create-transactionStage" class="col-sm-2 control-label">阶段<span style="font-size: 15px; color: red;">*</span></label>
			<div class="col-sm-10" style="width: 300px;">
			  <select class="form-control" id="create-stage" name="stage">
			  	<option></option>
			  	<c:forEach items="${stageList}" var="s">
					<option value="${s.value}">${s.text}</option>//value：传给后台，text:展示给前端
				</c:forEach>
			  </select>
			</div>
		</div>
		
		<div class="form-group">
			<label for="create-transactionType" class="col-sm-2 control-label">类型</label>
			<div class="col-sm-10" style="width: 300px;">
				<select class="form-control" id="create-transactionType" name="type">
				  <option></option>
					<c:forEach items="${transactionTypeList}" var="t">
						<option value="${t.value}">${t.text}</option>
					</c:forEach>
				</select>
			</div>
			<label for="create-possibility" class="col-sm-2 control-label">可能性</label>
			<div class="col-sm-10" style="width: 300px;">
				<input type="text" class="form-control" id="create-possibility">
			</div>
		</div>
		
		<div class="form-group">
			<label for="create-clueSource" class="col-sm-2 control-label">来源</label>
			<div class="col-sm-10" style="width: 300px;">
				<select class="form-control" id="create-clueSource" name="source">
				  <option></option>
					<c:forEach items="${sourceList}" var="s">
						<option value="${s.value}">${s.text}</option>
					</c:forEach>
				</select>
			</div>
			<label for="create-activitySrc" class="col-sm-2 control-label">市场活动源&nbsp;&nbsp;<a href="javascript:void(0);" data-toggle="modal" data-target="#findMarketActivity"><span class="glyphicon glyphicon-search"></span></a></label>
			<div class="col-sm-10" style="width: 300px;">
				<input type="text" class="form-control" id="activityName">
				<input type="hidden" name="activityId" id="activityId"/>
			</div>
		</div>
		
		<div class="form-group">
			<label for="create-contactsName" class="col-sm-2 control-label">联系人名称&nbsp;&nbsp;<a href="javascript:void(0);" data-toggle="modal" data-target="#findContacts"><span class="glyphicon glyphicon-search"></span></a></label>
			<div class="col-sm-10" style="width: 300px;">
				<input type="text" class="form-control" id="contactsName">
				<input type="hidden" name="contactsId" id="contactsId"/>
			</div>
		</div>
		
		<div class="form-group">
			<label for="create-describe" class="col-sm-2 control-label">描述</label>
			<div class="col-sm-10" style="width: 70%;">
				<textarea class="form-control" rows="3" id="create-describe" name="description"></textarea>
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
				<input type="text" class="form-control time2" id="create-nextContactTime" name="nextContactTime">
			</div>
		</div>
		
	</form>
</body>
</html>