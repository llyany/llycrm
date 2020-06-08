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

//刷新列表，第一次展示的页面和条数是要先明确的，之后想改才可以使用动态修改
        pageList(1,2);
		$(".time").datetimepicker({
			minView: "month",
			language:  'zh-CN',
			format: 'yyyy-mm-dd',
			autoclose: true,
			todayBtn: true,
			pickerPosition: "bottom-left"
		});
		//为修改按钮绑定事件，打开修改操作的模态窗口
		$("#editBtn").click(function () {

			var $xz = $("input[name=xz]:checked");

			if($xz.length==0){

				alert("请选择需要修改的记录");

			}else if($xz.length>1){

				alert("只能选择一条记录进行修改");

				//肯定选了，而且只选了一条
			}else{

				//$("#editActivityModal").modal("show");

				//var id = $($xz[0]).val();
				//虽然$xz操作的是复选框，但是我们现在是能够确定只选中了一条记录
				//我们就可以直接调用val方法来取值
				var id = $xz.val();

				$.ajax({

					url : "workbench/activity/getUserListAndActivity.do",
					//这里经过了两个查询，查询userList，查询activity
					data : {

						"id" : id

					},
					type : "get",
					dataType : "json",
					success : function (data) {

						/*

							data
								List<User> uList...
								Activity a
								{"uList":[{用户1},{2},{3}],"a":{市场活动}}

						 */

						var html = "<option></option>";

						//这里是获得下拉栏信息
						$.each(data.uList,function (i,n) {

							html += "<option value='"+n.id+"'>"+n.name+"</option>";

						})

						//为修改操作模态窗口的所有者下拉框铺值
						$("#edit-owner").html(html);

						//为修改操作模态窗口的表单元素铺值
						$("#edit-id").val(data.a.id);
						$("#edit-name").val(data.a.name);
						$("#edit-owner").val(data.a.owner);
						$("#edit-startDate").val(data.a.startDate);
						$("#edit-endDate").val(data.a.endDate);
						$("#edit-cost").val(data.a.cost);
						$("#edit-description").val(data.a.description);

						//打开修改操作的模态窗口
						$("#editActivityModal").modal("show");

					}

				})

			}


		})

		//为模态窗口的更新按钮绑定事件，执行市场活动的修改操作
		$("#updateBtn").click(function () {


			$.ajax({

				url : "workbench/activity/update.do",
				data : {

					"id" : $.trim($("#edit-id").val()),
					"owner" : $.trim($("#edit-owner").val()),
					"name" : $.trim($("#edit-name").val()),
					"startDate" : $.trim($("#edit-startDate").val()),
					"endDate" : $.trim($("#edit-endDate").val()),
					"cost" : $.trim($("#edit-cost").val()),
					"description" : $.trim($("#edit-description").val())


				},
				type : "post",
				dataType : "json",
				success : function (data) {


					if(data.success){

						//修改成功后
						//{"data":success/false}

						//刷新市场活动列表，这里就是展示信息的一种方式，脱离于修改模块，采用全局刷新覆盖的方式
						//每个增删改查都是操作加上页面信息的显示，所以将页面显示单独成一个模块，前提是这个模块要是刷新覆盖的html()
						//pageList(1,2);

						/*

							$("#activityPage").bs_pagination('getOption', 'currentPage'):
								维持当前页的页码
							$("#activityPage").bs_pagination('getOption', 'rowsPerPage')：
								维持每页展现的记录数

						 */
						pageList($("#activityPage").bs_pagination('getOption', 'currentPage')
								,$("#activityPage").bs_pagination('getOption', 'rowsPerPage'));


						//关闭模态窗口
						$("#editActivityModal").modal("hide");

					}else{

						alert("修改市场活动失败");

					}


				}

			})

		})

//为删除按钮绑定事件，执行市场活动删除操作
		$("#deleteBtn").click(function () {

			var $xz = $("input[name=xz]:checked");

			if($xz.length==0){

				alert("请选择需要删除的记录");

				//用户肯定是做选择了，而且选了多条
			}else{

				//ajax
				//url:workbench/activity/delete.do
				/*

					data : {

						"id" : xxx,
						"id" : xxx

					}

					我们可能要为后台同时传递多个id，所以参数有可能是同一个key下，有多个value
					这种需求，就必须以传统形式传递参数
					data : "id=xxx&id=xxx&id=xxx"


				 */

				/*

					在任何系统中，删除都属于危险行为，删除之后的结果难以恢复
					我们需要在执行删除操作前，给用户一个提示

				*/

				if(confirm("确定删除所选记录吗？")){

					var param = "";

					for(var i=0;i<$xz.length;i++){

						param += "id="+$($xz[i]).val();

						//如果不是最后一条记录
						if(i<$xz.length-1){

							param += "&";

						}

					}

					//alert(param);

					$.ajax({

						url : "workbench/activity/delete.do",
						data : param,
						type : "post",
						dataType : "json",
						success : function (data) {

							/*

                                data
                                    {"success":true/false}

                             */

							if(data.success){

								//删除成功后

								//刷新列表
								//pageList(1,2);
								pageList(1,$("#activityPage").bs_pagination('getOption', 'rowsPerPage'));
							}else{

								alert("删除市场活动失败");

							}


						}

					})

				}



			}

		})
		//为全选的复选框绑定事件，执行全选&反选操作
		$("#qx").click(function () {

			//如果挑√了
			/*if($("#qx").prop("checked")){

				//找到所有name为xz的复选框进行挑√操作
				$("input[name=xz]").prop("checked",true);

			//如果将√灭掉了
			}else{

				//找到所有name为xz的复选框进行灭√操作
				$("input[name=xz]").prop("checked",false);
			}*/
			$("input[name=xz]").prop("checked",this.checked);

		})

		/*$("input[name=xz]").click(function () {

			alert(123);

		})*/

		/*

			以上做法无效，是因为我们所有name=xz的input元素，都是我们动态拼接生成的
			动态生成的元素，不能按照传统的方式来绑定事件
			动态生成的元素，要以on的形式来绑定事件

			$(我们需要绑定的元素的有效的父级元素).on(触发事件的方式,需要绑定的元素,回调函数)

		 */

		$("#activityBody").on("click",$("input[name=xz]"),function () {

			$("#qx").prop("checked",$("input[name=xz]").length==$("input[name=xz]:checked").length);

		})

		//为创建按钮绑定事件，打开添加操作的模态窗口
		$("#addBtn").click(function () {

			/*

				操作模态窗口的方式：

					得到模态窗口的jquery对象，调用modal方法，为方法传递参数：
																			参数值：show 表示打开模态窗口
																					hide 表示关闭模态窗口

			 */

			/*alert(123);
			$("#createActivityModal").modal("show");*/

			/*

				发出请求（ajax）到后台，目的是为了取得用户信息列表
				前端得到了用户信息列表后，将用户表中的数据铺在所有者下拉框中
				最后打开模态窗口

			 */

			$.ajax({

				url : "workbench/activity/getUserList.do",
				type : "get",
				dataType : "json",
				success : function (data) {

					/*

						data
							List<User> uList
							[{用户1},{2},{3}]
							[{"id":?,"name":?,"loginAct":?,"email":?....},{2},{3}]

					 */

					var html = "<option></option>";

					//每一个n就是每一个数组中的json对象（相当于是每一个user对象）
					$.each(data,function (i,n) {

						html += "<option value='"+n.id+"'>"+n.name+"</option>";

					})

					//为所有者select铺option
					$("#create-owner").html(html);

					//使当前登录的用户作为所有者的默认选项
					//取得当前登录用户的id
					/*

						js中是可以使用el表达式的
						但是el表达式必须要套用在字符串引号中

					 */
					var id = "${user.id}";
					$("#create-owner").val(id);


					//所有者下拉框处理完毕后，打开添加操作的模态窗口
					$("#createActivityModal").modal("show");

				}

			})


		})


		//为保存按钮绑定事件，执行市场活动的添加操作
		$("#saveBtn").click(function () {

			$.ajax({

				url : "workbench/activity/save.do",
				data : {

					"owner" : $.trim($("#create-owner").val()),
					"name" : $.trim($("#create-name").val()),
					"startDate" : $.trim($("#create-startDate").val()),
					"endDate" : $.trim($("#create-endDate").val()),
					"cost" : $.trim($("#create-cost").val()),
					"description" : $.trim($("#create-description").val())


				},
				type : "post",
				dataType : "json",
				success : function (data) {

					/*

						data
							{"success":true/false}

					 */

					if(data.success){

						//添加成功后
						//清空添加操作模态窗口的表单信息
						/*

							jquery对象为我们提供了subimt()方法，用来提交表单
							但是，jquery对象并没有为我们提供reset()方法来重置表单

							jquery没有为我们提供重置方法，原生js的dom对象为我们提供了reset()方法

							jquery转化为dom：
								jquery对象[0]


							dom转化为jquery：
								$(dom)

						 */

						//刷新列表
						pageList(1,$("#activityPage").bs_pagination('getOption', 'rowsPerPage'));

						$("#activitySaveForm")[0].reset();

						//关闭模态窗口
						$("#createActivityModal").modal("hide");

					}else{

						alert("添加市场活动失败");

					}


				}

			})

		})
		//页面加载完毕后，局部刷新市场活动列表
		pageList(1,$("#activityPage").bs_pagination('getOption', 'rowsPerPage'));

        //为查询按钮绑定事件
        $("#searchBtn").click(function () {

            //alert("123")
            //将搜索框中的信息保存到隐藏域中
            $("#hidden-name").val($.trim($("#search-name").val()));
            $("#hidden-owner").val($.trim($("#search-owner").val()));
            $("#hidden-startDate").val($.trim($("#search-startDate").val()));
            $("#hidden-endDate").val($.trim($("#search-endDate").val()));
//刷新列表，这里也要明确首次使用的页面和条数
            pageList(1,2);
        })

	});

	/*


		pageList方法中的两个参数：
		pageNo：当前页的页码（第N页）
		pageSize：每页展现多少条记录
		对于分页操作而言，不论是哪种关系型数据库，前端的分页参数，我们就操作pageNo和pageSize，
		有了这两个参数，其他的分页相关的信息，都可以得到



	 */

	/*

		关于pageList方法：
			是用来查询并展现市场活动信息用的

		pageList方法的入口都有哪些？（都什么时候需要调用pageList方法刷新列表）
		（1）点击左侧菜单"市场活动"，进入到当前index.jsp页面，在页面加载完毕后，需要调用pageList，刷新市场活动列表
		（2）点击查询按钮，需要调用pageList，刷新市场活动列表
		（3）点击分页组件的时候，需要调用pageList，刷新市场活动列表
		（4）添加市场活动后，需要调用pageList，刷新市场活动列表
		（5）修改市场活动后，需要调用pageList，刷新市场活动列表
		（6）删除市场活动后，需要调用pageList，刷新市场活动列表

	 */

	/*

		我们将在pageList方法中，为后台发出ajax请求
		需要为后台传递哪些参数呢？

		分页查询：
		这2个参数是必须传递的，因为我们100%要做分页查询
		pageNo
		pageSize

		条件查询：
		这4个参数不是必须的，因为我们的6个入口，其中有些入口不需要这4个参数
		后台sql使用的是动态sql的机制，使用where标签结合if标签，当有参数的时候，就查询，如果没有参数，就不查询
		name
		owner
		startDate
		endDate


	 */

	function pageList(pageNo,pageSize) {

		//alert("刷新市场活动列表");

		//将全选√灭掉
		$("#qx").prop("checked",false);


		//将隐藏域中保存的信息取出，重新复制到搜索框上
		$("#search-name").val($.trim($("#hidden-name").val()));
		$("#search-owner").val($.trim($("#hidden-owner").val()));
		$("#search-startDate").val($.trim($("#hidden-startDate").val()));
		$("#search-endDate").val($.trim($("#hidden-endDate").val()));

		$.ajax({

			url : "workbench/activity/pageList.do",
			data : {

				"pageNo" : pageNo,
				"pageSize" : pageSize,
				"name" : $.trim($("#search-name").val()),
				"owner" : $.trim($("#search-owner").val()),
				"startDate" : $.trim($("#search-startDate").val()),
				"endDate" : $.trim($("#search-endDate").val())

			},
			type : "get",
			dataType : "json",
			success : function (data) {

				//alert(data);	//object Object

				/*

					data
						int total=100 : 总条数
						List<Activity> dataList :市场活动列表

						{"total":100,"dataList":[{市场活动1},{2},{3}]}


				 */

				var html = "";

				//每一个n就是每一个市场活动对象
				$.each(data.dataList,function (i,n) {

					html += '<tr class="active">';
					html += '<td><input type="checkbox" name="xz" value="'+n.id+'"/></td>';
					html += '<td><a style="text-decoration: none; cursor: pointer;" onclick="window.location.href=\'workbench/activity/detail.do?id='+n.id+'\';">'+n.name+'</a></td>';
					/*这里使用的是.do要经过controller处理参数信息，再把结果返回到要求的.jsp页面，就是采用两种展示信息的方式之一*/
					html += '<td>'+n.owner+'</td>';
					html += '<td>'+n.startDate+'</td>';
					html += '<td>'+n.endDate+'</td>';
					html += '</tr>';

				})
                //这里采用覆盖不是追加，后面处理备注时使用追加，两者各有优点，处理对应的模块
				$("#activityBody").html(html);

				//以上市场活动列表处理完毕后，接下来处理分页插件信息

				//计算总页数
				var totalPages = data.total%pageSize==0?data.total/pageSize:parseInt(data.total/pageSize)+1;

				$("#activityPage").bs_pagination({
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

	<input type="hidden" id="hidden-name"/>
	<input type="hidden" id="hidden-owner"/>
	<input type="hidden" id="hidden-startDate"/>
	<input type="hidden" id="hidden-endDate"/>

	<!-- 修改市场活动的模态窗口 -->
	<div class="modal fade" id="editActivityModal" role="dialog">
		<div class="modal-dialog" role="document" style="width: 85%;">
			<div class="modal-content">
				<div class="modal-header">
					<button type="button" class="close" data-dismiss="modal">
						<span aria-hidden="true">×</span>
					</button>
					<h4 class="modal-title" id="myModalLabel2">修改市场活动</h4>
				</div>
				<div class="modal-body">

					<form class="form-horizontal" role="form">

						<input type="hidden" id="edit-id"/>

						<div class="form-group">
							<label for="edit-marketActivityOwner" class="col-sm-2 control-label">所有者<span style="font-size: 15px; color: red;">*</span></label>
							<div class="col-sm-10" style="width: 300px;">
								<select class="form-control" id="edit-owner">
								</select>
							</div>
							<label for="edit-marketActivityName" class="col-sm-2 control-label">名称<span style="font-size: 15px; color: red;">*</span></label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control" id="edit-name">
							</div>
						</div>

						<div class="form-group">
							<label for="edit-startTime" class="col-sm-2 control-label">开始日期</label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control" id="edit-startDate">
							</div>
							<label for="edit-endTime" class="col-sm-2 control-label">结束日期</label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control" id="edit-endDate">
							</div>
						</div>

						<div class="form-group">
							<label for="edit-cost" class="col-sm-2 control-label">成本</label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control" id="edit-cost">
							</div>
						</div>

						<div class="form-group">
							<label for="edit-describe" class="col-sm-2 control-label">描述</label>
							<div class="col-sm-10" style="width: 81%;">
								<!--

									关于textarea：文本域

									文本域：
									（1）在没有值的情况下，标签对一定处于夹紧状态
									（2）文本域的表现形式与其他表单元素不同，其他的表单元素操作的都是value属性值
										文本域没有value属性，他的值是在文本域标签对中进行展现

										注意！！！
											文本域虽然没有value属性，而且操作的是标签对，但是文本域也是属于表单元素范畴
												只要是表单元素，我们就要使用val方法来对值进行操作

								-->


								<textarea class="form-control" rows="3" id="edit-description"></textarea>
							</div>
						</div>



					</form>

				</div>
				<div class="modal-footer">
					<button type="button" class="btn btn-default" data-dismiss="modal">关闭</button>
					<button type="button" class="btn btn-primary" id="updateBtn">更新</button>
				</div>
			</div>
		</div>
	</div>


	<!-- 创建市场活动的模态窗口 -->
	<div class="modal fade" id="createActivityModal" role="dialog">
		<div class="modal-dialog" role="document" style="width: 85%;">
			<div class="modal-content">
				<div class="modal-header">
					<button type="button" class="close" data-dismiss="modal">
						<span aria-hidden="true">×</span>
					</button>
					<h4 class="modal-title" id="myModalLabel1">创建市场活动</h4>
				</div>
				<div class="modal-body">
				
					<form id="activitySaveForm" class="form-horizontal" role="form">

						<div class="form-group">
							<label for="create-marketActivityOwner" class="col-sm-2 control-label">所有者<span style="font-size: 15px; color: red;">*</span></label>
							<div class="col-sm-10" style="width: 300px;">
								<select class="form-control" id="create-owner">

								</select>
							</div>
                            <label for="create-marketActivityName" class="col-sm-2 control-label">名称<span style="font-size: 15px; color: red;">*</span></label>
                            <div class="col-sm-10" style="width: 300px;">
                                <input type="text" class="form-control" id="create-name">
                            </div>
						</div>
						
						<div class="form-group">
							<label for="create-startTime" class="col-sm-2 control-label">开始日期</label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control time" id="create-startDate">
							</div>
							<label for="create-endTime" class="col-sm-2 control-label">结束日期</label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control time" id="create-endDate">
							</div>
						</div>
                        <div class="form-group">

                            <label for="create-cost" class="col-sm-2 control-label">成本</label>
                            <div class="col-sm-10" style="width: 300px;">
                                <input type="text" class="form-control" id="create-cost">
                            </div>
                        </div>
						<div class="form-group">
							<label for="create-describe" class="col-sm-2 control-label">描述</label>
							<div class="col-sm-10" style="width: 81%;">
								<textarea class="form-control" rows="3" id="create-description"></textarea>
							</div>
						</div>
						
					</form>
					
				</div>
				<div class="modal-footer">
					<!--

						data-dismiss="modal"
							关闭模态窗口

					-->
					<button type="button" class="btn btn-default" data-dismiss="modal">关闭</button>
					<button type="button" class="btn btn-primary" id="saveBtn">保存</button>
				</div>
			</div>
		</div>
	</div>
	

	
	
	
	
	<div>
		<div style="position: relative; left: 10px; top: -10px;">
			<div class="page-header">
				<h3>市场活动列表</h3>
			</div>
		</div>
	</div>
	<div style="position: relative; top: -20px; left: 0px; width: 100%; height: 100%;">
		<div style="width: 100%; position: absolute;top: 5px; left: 10px;">
		
			<div class="btn-toolbar" role="toolbar" style="height: 80px;">
				<form class="form-inline" role="form" style="position: relative;top: 8%; left: 5px;">
				  
				  <div class="form-group">
				    <div class="input-group">
				      <div class="input-group-addon">名称</div>
				      <input class="form-control" type="text" id="search-name">
				    </div>
				  </div>
				  
				  <div class="form-group">
				    <div class="input-group">
				      <div class="input-group-addon">所有者</div>
				      <input class="form-control" type="text" id="search-owner">
				    </div>
				  </div>


				  <div class="form-group">
				    <div class="input-group">
				      <div class="input-group-addon">开始日期</div>
					  <input class="form-control" type="text" id="search-startDate" />
				    </div>
				  </div>
				  <div class="form-group">
				    <div class="input-group">
				      <div class="input-group-addon">结束日期</div>
					  <input class="form-control" type="text" id="search-endDate">
				    </div>
				  </div>
				  
				  <button type="button" class="btn btn-default" id="searchBtn">查询</button>
				  
				</form>
			</div>
			<div class="btn-toolbar" role="toolbar" style="background-color: #F7F7F7; height: 50px; position: relative;top: 5px;">
				<div class="btn-group" style="position: relative; top: 18%;">
					<!--

						data-toggle="modal"
							表示触发按钮，我们要弹出一个模态窗口（模态框）

						data-target="#createActivityModal"
							表示要打开哪个模态窗口，通过#id的形式找到指定的div

						我们想要在点击创建按钮之后，打开模态窗口之前，先弹出一个alert(123)
						现在是做不到的，因为用来操作模态窗口的data-toggle="modal" data-target="#createActivityModal"这两属性和属性值是写死到了我们的按钮元素的属性中
						所以造成了，我们只要点击按钮，属性和属性值就会随之生效

						以后我们对于按钮的操作，不应该将属性和属性值写死，我们应该为按钮绑定事件，至于按钮的行为应该由我们自己写js代码来决定

					-->
				  <button type="button" class="btn btn-primary" id="addBtn"><span class="glyphicon glyphicon-plus"></span> 创建</button>
				  <button type="button" class="btn btn-default" id="editBtn"><span class="glyphicon glyphicon-pencil"></span> 修改</button>
				  <button type="button" class="btn btn-danger" id="deleteBtn"><span class="glyphicon glyphicon-minus"></span> 删除</button>
				</div>
				
			</div>
			<div style="position: relative;top: 10px;">
				<table class="table table-hover">
					<thead>
						<tr style="color: #B3B3B3;">
							<td><input type="checkbox" id="qx"/></td>
							<td>名称</td>
                            <td>所有者</td>
							<td>开始日期</td>
							<td>结束日期</td>
						</tr>
					</thead>
					<tbody id="activityBody">
						<%--<tr class="active">
							<td><input type="checkbox" /></td>
							<td><a style="text-decoration: none; cursor: pointer;" onclick="window.location.href='workbench/activity/detail.jsp';">发传单</a></td>
                            <td>zhangsan</td>
							<td>2020-10-10</td>
							<td>2020-10-20</td>
						</tr>
                        <tr class="active">
                            <td><input type="checkbox" /></td>
                            <td><a style="text-decoration: none; cursor: pointer;" onclick="window.location.href='detail.jsp';">发传单</a></td>
                            <td>zhangsan</td>
                            <td>2020-10-10</td>
                            <td>2020-10-20</td>
                        </tr>--%>
					</tbody>
				</table>
			</div>
			
			<div style="height: 50px; position: relative;top: 30px;">

				<div id="activityPage"></div>
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