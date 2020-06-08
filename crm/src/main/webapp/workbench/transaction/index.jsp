<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
String basePath = request.getScheme() + "://" + request.getServerName() + ":" + request.getServerPort() + request.getContextPath() + "/";
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
	<link rel="stylesheet" type="text/css" href="jquery/bs_pagination/jquery.bs_pagination.min.css">
	<script type="text/javascript" src="jquery/bs_pagination/jquery.bs_pagination.min.js"></script>
	<script type="text/javascript" src="jquery/bs_pagination/en.js"></script>

<script type="text/javascript">

	$(function(){
		//首次刷新列表，这里要明确首次使用的页面和条数
		pageList(1,2)
		//全选
		$("#qx").click(function () {
		    //由全选框决定checkbox
			$("input[name=xz]").prop("checked",this.checked)
		})
		//反选(动态元素)，思路：由选择的checkbox决定全选框
        //动态生成的元素，要以on的形式来绑定事件
        //$(我们需要绑定的元素的有效的父级元素).on(触发事件的方式,需要绑定的元素,回调函数)
        $("#tranBody").on("click",$("input[name=xz]"),function () {

            $("#qx").prop("checked",$("input[name=xz]").length==$("input[name=xz]:checked").length);

        })
		$("#searchBtn").click(function () {
			//把信息预先放入隐藏域中
			$("#hidden-owner").val($.trim($("#search-owner").val()))
			$("#hidden-name").val($.trim($("#search-name").val()))
			$("#hidden-customerId").val($.trim($("#search-customerId").val()))
			$("#hidden-stage").val($.trim($("#search-stage").val()))
			$("#hidden-type").val($.trim($("#search-type").val()))
			$("#hidden-source").val($.trim($("#search-source").val()))
			$("#hidden-contactsId").val($.trim($("#search-contactsId").val()))
			//首次刷新列表，这里也要明确首次使用的页面和条数
			pageList(1,2)
		})
		//创建：使用onclick，这里不用传特定的参数，所以直接用
		//修改：需要传动态参数，需要额外操作
		$("#editBtn").click(function () {
			//勾选修改项
			var $xz = $("input[name=xz]:checked")
			if ($xz.length == 0) {
				alert("请勾选要修改的项")
			}else if ($xz.length > 1) {
				alert("只能勾选一项")
			}else {
				//把修改项的id传给后台
				var id = $xz.val()
				/*$.ajax({

					url : "workbench/transaction/getInfo.do",
					data : {
						"id":id
					},
					type : "get",
					dataType : "json",
					success : function (data) {
						if (data !=null) {
							window.location.href='workbench/transaction/edit.jsp'
						}

					}
				})*/
				window.location.href='workbench/transaction/getInfo.do?id='+id+''
			}//后台处理数据，然后转到edit.jsp
		})
		//删除
		$("#deleteBtn").click(function () {
			var $xz = $("input[name=xz]:checked")
			//可以同时删好几项
			if ($xz.length == 0) {
				alert("请选择要删除的项")
			}else {
				if(confirm("确认删除吗？")){
					var param =''
					//id=xxx&id=xxx&id=xxx...
					for (var i =0;i<$xz.length;i++) {
						param += "id="+$($xz[i]).val()
						if (i<$xz.length-1){
							param +="&"
						}
					}

					$.ajax({
						url : "workbench/transaction/delete.do",
						data : param,
						type : "post",
						dataType : "json",
						success : function (data) {
							//刷新页面
							if (data.success){
								pageList(1,2)
							}else {
								alert("删除失败")
							}
						}

					})
				}
			}

		})
	});
	function pageList(pageNo,pageSize){
		//把全选框去掉
		$("#qx").prop("checked",false)
//从隐藏域中获得信息，放入对应标签
		$("#search-owner").val($.trim($("#hidden-owner").val()))
		$("#search-name").val($.trim($("#hidden-name").val()))
		$("#search-customerId").val($.trim($("#hidden-customerId").val()))
		$("#search-stage").val($.trim($("#hidden-stage").val()))
		$("#search-type").val($.trim($("#hidden-type").val()))
		$("#search-source").val($.trim($("#hidden-source").val()))
		$("#search-contactsId").val($.trim($("#hidden-contactsId").val()))
		$.ajax({

			url : "workbench/transaction/pageList.do",
			data : {
				"pageNo"	:pageNo,
				"pageSize"	:pageSize,
				"owner"    	:$.trim($("#search-owner").val()),
				"name"     	:$.trim($("#search-name").val()),//先设定为tran表中的交易name
				"customerId":$.trim($("#search-customerId").val()),
				"stage"		:$.trim($("#search-stage").val()),
				"type"		:$.trim($("#search-type").val()),
				"source"	:$.trim($("#search-source").val()),
				"contactsId":$.trim($("#search-contactsId").val()),
			},
			type : "post",
			dataType : "json",
			success : function (data) {
					// alert("11")
					// pageList(1,2)
					/*
					* 返回：{"total":total,"dataList":{交易1},{2}...}
					* */

					var html = ''
					$.each(data.dataList,function (i,n) {

						html += '<tr>',
						html += '<td><input type="checkbox" name="xz" value="'+n.id+'"/></td> ',
						html += '<td><a style="text-decoration: none; cursor: pointer;" onclick="window.location.href=\'workbench/transaction/detail.do?id='+n.id+'\';">'+n.name+'</a></td>',
						html += '<td>'+n.customerId+'</td>',
						html += '<td>'+n.stage+'</td>',
						html += '<td>'+n.type+'</td>',
						html += '<td>'+n.owner+'</td>',
						html += '<td>'+n.source+'</td>',
						html += '<td>'+n.contactsId+'</td>',
						html += '</tr>'
					})
				$("#tranBody").html(html)
//计算总页数
				var totalPages =data.total%pageSize==0?data.total/pageSize:parseInt(data.total/pageSize)+1
				//alert("111")
		$("#tranPage").bs_pagination({
			currentPage: pageNo, // 页码
			rowsPerPage: pageSize, // 每页显示的记录条数
			maxRowsPerPage: 20, // 每页最多显示的记录条数
			totalPages: totalPages, // 总页数
			totalRows: data.total, // 总记录条数

			visiblePageLinks: 3, // 显示几个卡片

			showGoToPage: true,
			showRowsPerPage: true,
			showRowsInfo: true,
			showRowsDefaultInfo: true,

			//该回调函数的触发时机：当点击分页查询的时候触发
			onChangePage : function(event, data){
				pageList(data.currentPage , data.rowsPerPage);
			}
		});
			}

		})


	}
</script>
</head>
<body>

	<input type="hidden" id="hidden-owner">
	<input type="hidden" id="hidden-name">
	<input type="hidden" id="hidden-customerId">
	<input type="hidden" id="hidden-stage">
	<input type="hidden" id="hidden-type">
	<input type="hidden" id="hidden-source">
	<input type="hidden" id="hidden-contactsId">

	<div>
		<div style="position: relative; left: 10px; top: -10px;">
			<div class="page-header">
				<h3>交易列表</h3>
			</div>
		</div>
	</div>
	
	<div style="position: relative; top: -20px; left: 0px; width: 100%; height: 100%;">
	
		<div style="width: 100%; position: absolute;top: 5px; left: 10px;">
		
			<div class="btn-toolbar" role="toolbar" style="height: 80px;">
				<form class="form-inline" role="form" style="position: relative;top: 8%; left: 5px;">
				  
				  <div class="form-group">
				    <div class="input-group">
				      <div class="input-group-addon">所有者</div>
				      <input class="form-control" type="text" id="search-owner">
				    </div>
				  </div>
				  
				  <div class="form-group">
				    <div class="input-group">
				      <div class="input-group-addon">名称</div>
				      <input class="form-control" type="text" id="search-name">
				    </div>
				  </div>
				  
				  <div class="form-group">
				    <div class="input-group">
				      <div class="input-group-addon">客户名称</div>
				      <input class="form-control" type="text" id="search-customerId">
				    </div>
				  </div>
				  
				  <br>
				  
				  <div class="form-group">
				    <div class="input-group">
				      <div class="input-group-addon">阶段</div>
					  <select class="form-control" id="search-stage">
					  	<option></option>
					  	<option>资质审查</option>
					  	<option>需求分析</option>
					  	<option>价值建议</option>
					  	<option>确定决策者</option>
					  	<option>提案/报价</option>
					  	<option>谈判/复审</option>
					  	<option>成交</option>
					  	<option>丢失的线索</option>
					  	<option>因竞争丢失关闭</option>
					  </select>
				    </div>
				  </div>
				  
				  <div class="form-group">
				    <div class="input-group">
				      <div class="input-group-addon">类型</div>
					  <select class="form-control" id="search-type">
					  	<option></option>
					  	<option>已有业务</option>
					  	<option>新业务</option>
					  </select>
				    </div>
				  </div>
				  
				  <div class="form-group">
				    <div class="input-group">
				      <div class="input-group-addon">来源</div>
				      <select class="form-control" id="search-source">
						  <option></option>
						  <option>广告</option>
						  <option>推销电话</option>
						  <option>员工介绍</option>
						  <option>外部介绍</option>
						  <option>在线商场</option>
						  <option>合作伙伴</option>
						  <option>公开媒介</option>
						  <option>销售邮件</option>
						  <option>合作伙伴研讨会</option>
						  <option>内部研讨会</option>
						  <option>交易会</option>
						  <option>web下载</option>
						  <option>web调研</option>
						  <option>聊天</option>
						</select>
				    </div>
				  </div>
				  
				  <div class="form-group">
				    <div class="input-group">
				      <div class="input-group-addon">联系人名称</div>
				      <input class="form-control" type="text" id="search-contactsId">
				    </div>
				  </div>
				  
				  <button type="button" class="btn btn-default" id="searchBtn">查询</button>
				  
				</form>
			</div>
			<div class="btn-toolbar" role="toolbar" style="background-color: #F7F7F7; height: 50px; position: relative;top: 10px;">
				<div class="btn-group" style="position: relative; top: 18%;">
				  <button type="button" class="btn btn-primary" onclick="window.location.href='workbench/transaction/getUserList.do';"><span class="glyphicon glyphicon-plus"></span> 创建</button>
				  <button type="button" class="btn btn-default" id="editBtn"><span class="glyphicon glyphicon-pencil"></span> 修改</button>
				  <button type="button" class="btn btn-danger" id="deleteBtn"><span class="glyphicon glyphicon-minus"></span> 删除</button>
				</div>
				
				
			</div>
			<div style="position: relative;top: 10px;">
				<table class="table table-hover">
					<thead>
						<tr style="color: #B3B3B3;">
							<td><input type="checkbox" id="qx" /></td>
							<td>名称</td>
							<td>客户名称</td>
							<td>阶段</td>
							<td>类型</td>
							<td>所有者</td>
							<td>来源</td>
							<td>联系人名称</td>
						</tr>
					</thead>
					<tbody id="tranBody">
						<%--<tr>
							<td><input type="checkbox" /></td>
							<td><a style="text-decoration: none; cursor: pointer;" onclick="window.location.href='workbench/transaction/detail.do?id=c0072929c0524d31af7aaae7e2bd8d31';">阿里交易01</a></td>
							<td>动力节点</td>
							<td>谈判/复审</td>
							<td>新业务</td>
							<td>zhangsan</td>
							<td>广告</td>
							<td>李四</td>
						</tr>
                        <tr class="active">
                            <td><input type="checkbox" /></td>
                            <td><a style="text-decoration: none; cursor: pointer;" onclick="window.location.href='detail.html';">动力节点-交易01</a></td>
                            <td>动力节点</td>
                            <td>谈判/复审</td>
                            <td>新业务</td>
                            <td>zhangsan</td>
                            <td>广告</td>
                            <td>李四</td>
                        </tr>--%>
					</tbody>
				</table>
			</div>
			
			<div style="height: 50px; position: relative;top: 20px;">
				<div id="tranPage"></div>
				<%--<div>
					<button type="button" class="btn btn-default" style="cursor: default;">共<b>50</b>条记录</button>
				</div>
				<div class="btn-group" style="position: relative;top: -34px; left: 110px;">
					<button type="button" class="btn btn-default" style="cursor: default;">显示</button>
					<div class="btn-group">
						<button type="button" class="btn btn-default dropdown-toggle" data-toggle="dropdown">
							10
							<span class="caret"></span>
						</button>
						<ul class="dropdown-menu" role="menu">
							<li><a href="#">20</a></li>
							<li><a href="#">30</a></li>
						</ul>
					</div>
					<button type="button" class="btn btn-default" style="cursor: default;">条/页</button>
				</div>
				<div style="position: relative;top: -88px; left: 285px;">
					<nav>
						<ul class="pagination">
							<li class="disabled"><a href="#">首页</a></li>
							<li class="disabled"><a href="#">上一页</a></li>
							<li class="active"><a href="#">1</a></li>
							<li><a href="#">2</a></li>
							<li><a href="#">3</a></li>
							<li><a href="#">4</a></li>
							<li><a href="#">5</a></li>
							<li><a href="#">下一页</a></li>
							<li class="disabled"><a href="#">末页</a></li>
						</ul>
					</nav>
				</div>--%>
			</div>
			
		</div>
		
	</div>
</body>
</html>