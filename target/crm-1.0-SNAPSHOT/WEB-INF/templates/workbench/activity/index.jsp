<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%
	String basePath = request.getScheme() + "://" + request.getServerName() + ":" + request.getServerPort() + request.getContextPath() + "/";
%>
<html>
	<head>
		<meta charset="UTF-8">
		<base href="<%=basePath%>">

		<link href="jquery/bootstrap_3.3.0/css/bootstrap.min.css" type="text/css" rel="stylesheet"/>
		<link href="jquery/bootstrap-datetimepicker-master/css/bootstrap-datetimepicker.min.css" type="text/css" rel="stylesheet"/>
		<link href="jquery/bs_pagination-master/css/jquery.bs_pagination.min.css" type="text/css" rel="stylesheet"/>

		<script type="text/javascript" src="jquery/jquery-1.11.1-min.js"></script>
		<script type="text/javascript" src="jquery/bootstrap_3.3.0/js/bootstrap.min.js"></script>
		<script type="text/javascript" src="jquery/bootstrap-datetimepicker-master/js/bootstrap-datetimepicker.js"></script>
		<script type="text/javascript" src="jquery/bootstrap-datetimepicker-master/locale/bootstrap-datetimepicker.zh-CN.js"></script>
		<script type="text/javascript" src="jquery/bs_pagination-master/js/jquery.bs_pagination.min.js"></script>
		<script type="text/javascript" src="jquery/bs_pagination-master/localization/en.js"></script>

		<script type="text/javascript">
            $(function () {
                //新建活动按钮的单击事件
                $("#createActivityBtn").click(function () {
                    //重置表单, 	.get(0)或者[0]是获取jQuery对象的dom节点,		reset方法是js的,jQuery对象没有reset方法
                    $("#createActivityForm").get(0).reset();
                    //显示模态窗口
                    $("#createActivityModal").modal("show");
                });

                //日历
                $(".createDate,.queryDate,.updateDate").datetimepicker({
                    language: 'zh-CN',
                    format: 'yyyy-mm-dd',
                    minView: 'month',
                    initialDate: new Date(),
                    autoclose: true,
                    todayBtn: true,
                    clearBtn: true
                });

                //新建活动模态窗口的保存按钮单击事件
                $("#saveCreateActivityBtn").click(function () {
                    //参数
                    var owner = $("#create-marketActivityOwner").val();
                    var name = $.trim($("#create-marketActivityName").val());
                    var startDate = $("#create-startDate").val();
                    var endDate = $("#create-endDate").val();
                    var cost = $.trim($("#create-cost").val());
                    var describe = $.trim($("#create-describe").val());

                    //数据验证
                    if (owner == "") {
                        alert("所有者不能为空");
                        return;
                    }
                    if (name == "") {
                        alert("活动名称不能为空");
                        return;
                    }
                    if (startDate != "" && endDate != "") {
                        if (startDate > endDate) {
                            alert("结束日期不能早于开始日期");
                            return;
                        }
                    }
                    //正则表达式来判断cost是否合法,非负整数
                    //        非负整数:	/^(([1-9]\d*)|0)$/
                    var zz = /^(([1-9]\d*)|0)$/;
                    if (!zz.test(cost) && cost != "") {
                        alert("成本只能是非负整数");
                        return;
                    }
                    //发送请求
                    $.ajax({
                        url: 'workbench/activity/saveCreateActivity.do',
                        data: {
                            owner: owner,
                            name: name,
                            startDate: startDate,
                            endDate: endDate,
                            cost: cost,
                            description: describe
                        },
                        type: 'post',
                        dataType: 'json',
                        success: function (data) {
                            if (data.code == "1") {
                                //关闭模态窗口,刷新页面
                                $("#createActivityModal").modal("hide");
                                //刷新界面,显示第一页,保持每页显示条数不变
                                queryActivityByConditionForPage(1, $("#activityPage").bs_pagination('getOption', 'rowsPerPage'));
                            } else {
                                //显示失败提示信息
                                alert(data.message);
                                //模态窗口不关闭,但要刷一下(习惯)
                                $("#createActivityModal").modal("show");
                            }
                        }
                    });
                });

                //主页面加载完成时,查询并显示活动列表,所有数据的第一页	默认每页显示5条记录
                queryActivityByConditionForPage(1, 5);

                //查询按钮单击事件
                $("#queryBtn").click(function () {
                    //根据条件查询,显示第一页,保持每页显示条数不变
                    queryActivityByConditionForPage(1, $("#activityPage").bs_pagination('getOption', 'rowsPerPage'));
                });

                //全选按钮单击事件
                $("#checkAll").click(function () {
                    //点击时为选中状态,则所有都选中
                    /*if (this.checked) {
                        //父子选择器  用"空格"可以选择间接子标签,不能用">"(只能选择直接子标签)
                        $("#tBody input[type='checkbox']").prop("checked", true);
                    } else {
                        $("#tBody input[type='checkbox']").prop("checked", false);
                    }*/

                    //简化上面这段代码
                    $("#tBody input[type='checkbox']").prop("checked", this.checked);
                });

                //活动列表选择框与全选框的联动,当有任意一个反选时,全选应该变为false
                //固有元素添加事件按下面写,这里如果这样写,则不会触发,因为显示列表发的异步请求
                //$("#tBody input[type='checkbox']").click(function (){});
                //动态生成的元素,应该使用jQuery的on函数:	(直接/间接)父选择器(必须是固有元素).on("事件类型",子选择器,function(){//js代码});
                $("#tBody").on("click", "input[type='checkbox']", function () {
                    if ($("#tBody input[type='checkbox']").size() == $("#tBody input[type='checkbox']:checked").size()) {
                        $("#checkAll").prop("checked", true);
                    } else {
                        $("#checkAll").prop("checked", false);
                    }
                });

                //删除按钮单击事件
                $("#deleteBtn").click(function () {
                    var checkedIds = $("#tBody input[type='checkbox']:checked");
                    if (checkedIds.size() == 0) {
                        alert("请选择要删除的市场活动");
                        return;
                    }
                    var ids = "";
                    $.each(checkedIds, function () {
                        ids += "id=" + this.value + "&";
                    });
                    ids = ids.substring(0, ids.length - 1);
                    if (window.confirm("确定删除?")) {
                        $.ajax({
                            url: 'workbench/activity/deleteActivityByIds.do',
                            data: ids,
                            type: 'post',
                            dataType: 'json',
                            tradition: true,		//true就会去掉[],从 a[]=1&a[]=2 变成 a=1&a=2
                            success: function (data) {
                                if (data.code == "1") {
                                    //刷新列表
                                    queryActivityByConditionForPage(1, $("#activityPage").bs_pagination('getOption', 'rowsPerPage'));
                                } else {
                                    //提示信息
                                    alert(data.message);
                                }
                            }
                        });
                    }
                });

                //修改按钮单击事件
                $("#updateBtn").click(function () {
                    var checkedId = $("#tBody input[type='checkbox']:checked");
                    if (checkedId.size() == 0) {
                        alert("请选中一个活动再点击修改");
                        return;
                    }
                    if (checkedId.size() > 1) {
                        alert("只能选中一个活动,不能选中多个");
                        return;
                    }
                    var id = checkedId.val();	//或者var id=checkedId.get(0).value;  或者var id=checkedId[0].value;
                    $.ajax({
                        url: 'workbench/activity/queryActivityById.do',
                        data: {
                            id: id
                        },
                        type: 'post',
                        dataType: 'json',
                        success: function (data) {
                            $("#activityId").val(data.id);
                            $("#edit-marketActivityOwner").val(data.owner);
                            $("#edit-marketActivityName").val(data.name);
                            $("#edit-startDate").val(data.startDate);
                            $("#edit-endDate").val(data.endDate);
                            $("#edit-cost").val(data.cost);
                            $("#edit-describe").val(data.description);
                            $("#editActivityModal").modal("show");
                        }
                    });
                });

                //修改窗口"更新"按钮单击事件
                $("#confirmUpdateBtn").click(function () {
                    var id = $("#activityId").val();
                    var owner = $("#edit-marketActivityOwner").val();
                    var name = $.trim($("#edit-marketActivityName").val());
                    var startDate = $("#edit-startDate").val();
                    var endDate = $("#edit-endDate").val();
                    var cost = $.trim($("#edit-cost").val());
                    var describe = $.trim($("#edit-describe").val());
                    var editBy = "${sessionScope.sessionUser.id}";

                    //数据验证
                    if (owner == "") {
                        alert("所有者不能为空");
                        return;
                    }
                    if (name == "") {
                        alert("活动名称不能为空");
                        return;
                    }
                    if (startDate != "" && endDate != "") {
                        if (startDate > endDate) {
                            alert("结束日期不能早于开始日期");
                            return;
                        }
                    }
                    //正则表达式来判断cost是否合法,非负整数
                    //        非负整数:	/^(([1-9]\d*)|0)$/
                    var zz = /^(([1-9]\d*)|0)$/;
                    if (!zz.test(cost) && cost != "") {
                        alert("成本只能是非负整数");
                        return;
                    }

                    if (window.confirm("确定更新?")) {
                        $.ajax({
                            url: 'workbench/activity/editActivity.do',
                            data: {
                                id: id,
                                owner: owner,
                                name: name,
                                startDate: startDate,
                                endDate: endDate,
                                cost: cost,
                                description: describe,
                                editBy: editBy
                            },
                            type: 'post',
                            dataType: 'json',
                            success: function (data) {
                                if (data.code == "1") {
                                    alert("更新成功");
                                    $("#editActivityModal").modal("hide");
                                    queryActivityByConditionForPage(
                                        $("#activityPage").bs_pagination('getOption', 'currentPage'),
                                        $("#activityPage").bs_pagination('getOption', 'rowsPerPage')
                                    );
                                } else {
                                    alert(data.message);
                                    $("#editActivityModal").modal("show");
                                }
                            }
                        });
                    }
                });

                //批量导出
                $("#exportActivityAllBtn").click(function () {
                    //文件下载-->同步请求
                    window.location.href = "workbench/activity/exportAllActivity.do";
                });

                //选择导出
                $("#exportActivityXzBtn").click(function () {
                    var checkedIds = $("#tBody input[type='checkbox']:checked");
                    if (checkedIds.size() == 0) {
                        alert("请选择要导出的市场活动");
                        return;
                    }
                    var ids = "";
                    $.each(checkedIds, function () {
                        ids += "id=" + this.value + "&";
                    });
                    ids = ids.substring(0, ids.length - 1);
                    window.location.href = "workbench/activity/exportActivityByIds.do?" + ids;
                });

                //导入按钮单击事件
                $("#importActivityBtn").click(function () {
                    var activityFileName = $("#activityFile").val();//只是文件名,不是文件
                    //验证文件后缀xls
                    if (activityFileName.substr(activityFileName.lastIndexOf(".") + 1).toLowerCase() != "xls") {
                        alert("只支持xls文件");
                        return;
                    }
                    var activityFile = $("#activityFile")[0].files[0];//获取文件内容   files本身是数组,但目前浏览器只支持1个,因此用0获取
                    //验证文件大小(5M)
                    if (activityFile.size > 5 * 1024 * 1024) {
                        alert("文件大于5MB,请修改后重试");
                        return;
                    }

                    //FormData是ajax提供的接口,可以模拟键值对向后台提交参数    最大的优势是能提交二进制数据
                    var formData = new FormData();
                    formData.append("activityFile", activityFile);

                    $.ajax({
                        url: 'workbench/activity/importActivity.do',
                        data: formData,
                        processData: false,//是否把ajax所有的参数转换为字符串
                        contentType: false,//是否把ajax所有的参数按默认的编码格式编码(urlencoded)
                        type: 'post',
                        dataType: 'json',
                        success: function (data) {
                            if (data.code == "1") {
                                alert("成功导入" + data.retData + "条记录");
                                $("#importActivityModal").modal("hide");
                                queryActivityByConditionForPage(1, $("#activityPage").bs_pagination('getOption', 'rowsPerPage'));
                            } else {
                                alert(data.message);
                                $("#importActivityModal").modal("show");
                            }
                        }
                    });
                });
            });

            //在入口函数外封装函数
            //函数:	根据条件查询活动列表并分页
            function queryActivityByConditionForPage(pageNo, pageSize) {
                var name = $("#query-name").val();
                var owner = $("#query-owner").val();
                var startDate = $("#query-startDate").val();
                var endDate = $("#query-endDate").val();
                // var pageNo=pageNo;//放到形参位置
                // var pageSize=pageSize;
                $.ajax({
                    url: 'workbench/activity/queryActivityByConditionForPage.do',
                    data: {
                        name: name,
                        owner: owner,
                        startDate: startDate,
                        endDate: endDate,
                        pageNo: pageNo,
                        pageSize: pageSize
                    },
                    type: 'post',
                    dataType: 'json',
                    success: function (data) {
                        //显示总条数
                        //$("#countB").text(data.count);
                        //遍历显示列表
                        var htmlStr = "";
                        <!-- /为转义符,可以避免改"为' -->
                        $.each(data.activityList, function (index, obj) {
                            htmlStr += "<tr class=\"active\">";
                            htmlStr += "<td><input type=\"checkbox\" value=\"" + obj.id + "\"/></td>";
                            htmlStr += "<td><a style=\"text-decoration: none; cursor: pointer;\" onclick=\"window.location.href='workbench/activity/detailOfActivity.do?activityId=" + obj.id + "'\">" + obj.name + "</a></td>";
                            htmlStr += "<td>" + obj.owner + "</td>";
                            htmlStr += "<td>" + obj.startDate + "</td>";
                            htmlStr += "<td>" + obj.endDate + "</td>";
                            htmlStr += "</tr>";
                        });
                        $("#tBody").html(htmlStr);
                        //当每次刷新活动列表,取消全选
                        $("#checkAll").prop("checked", false);

                        //计算总页数
                        var totalPage = parseInt(data.count / pageSize);
                        if (data.count % pageSize != 0) {
                            totalPage += 1;
                        }
                        //调用分页插件
                        $("#activityPage").bs_pagination({
                            currentPage: pageNo,//当前页码
                            rowsPerPage: pageSize,//每页显示条数
                            totalRows: data.count,//总条数
                            totalPages: totalPage,//总页数
                            visiblePageLinks: 5,//最多显示的导航页码数
                            showGoToPage: true,//显示"跳转到"按钮
                            showRowsPerPage: true,//显示"每页显示条数"
                            showRowsInfo: true,//显示分页信息

                            //翻页  pageObj封装了上面这些参数
                            onChangePage: function (event, pageObj) {
                                queryActivityByConditionForPage(pageObj.currentPage, pageObj.rowsPerPage)
                            }
                        });
                    }
                });
            }
		</script>
	</head>
	<body>

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
						<form id="createActivityForm" class="form-horizontal" role="form">
							<div class="form-group">
								<label for="create-marketActivityOwner" class="col-sm-2 control-label">所有者<span
										style="font-size: 15px; color: red;">*</span></label>
								<div class="col-sm-10" style="width: 300px;">
									<select class="form-control" id="create-marketActivityOwner">
										<c:forEach items="${userList}" var="user">
											<option value="${user.id}">${user.name}</option>
										</c:forEach>
									</select>
								</div>
								<label for="create-marketActivityName" class="col-sm-2 control-label">名称<span
										style="font-size: 15px; color: red;">*</span></label>
								<div class="col-sm-10" style="width: 300px;">
									<input type="text" class="form-control" id="create-marketActivityName">
								</div>
							</div>
							<div class="form-group">
								<label for="create-startDate" class="col-sm-2 control-label">开始日期</label>
								<div class="col-sm-10" style="width: 300px;">
									<input type="text" class="form-control createDate" id="create-startDate" readonly>
								</div>
								<label for="create-endDate" class="col-sm-2 control-label">结束日期</label>
								<div class="col-sm-10" style="width: 300px;">
									<input type="text" class="form-control createDate" id="create-endDate" readonly>
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
									<textarea class="form-control" rows="3" id="create-describe"></textarea>
								</div>
							</div>
						</form>
					</div>
					<div class="modal-footer">
						<button type="button" class="btn btn-default" data-dismiss="modal">关闭</button>
						<button id="saveCreateActivityBtn" type="button" class="btn btn-primary">保存</button>
					</div>
				</div>
			</div>
		</div>

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
							<input type="hidden" id="activityId">
							<div class="form-group">
								<label for="edit-marketActivityOwner" class="col-sm-2 control-label">所有者<span
										style="font-size: 15px; color: red;">*</span></label>
								<div class="col-sm-10" style="width: 300px;">
									<select class="form-control" id="edit-marketActivityOwner">
										<c:forEach items="${userList}" var="user">
											<option value="${user.id}">${user.name}</option>
										</c:forEach>
									</select>
								</div>
								<label for="edit-marketActivityName" class="col-sm-2 control-label">名称<span
										style="font-size: 15px; color: red;">*</span></label>
								<div class="col-sm-10" style="width: 300px;">
									<input type="text" class="form-control" id="edit-marketActivityName">
								</div>
							</div>
							<div class="form-group">
								<label for="edit-startDate" class="col-sm-2 control-label">开始日期</label>
								<div class="col-sm-10" style="width: 300px;">
									<input type="text" class="form-control updateDate" id="edit-startDate" readonly>
								</div>
								<label for="edit-endDate" class="col-sm-2 control-label">结束日期</label>
								<div class="col-sm-10" style="width: 300px;">
									<input type="text" class="form-control updateDate" id="edit-endDate" readonly>
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
									<textarea class="form-control" rows="3" id="edit-describe"></textarea>
								</div>
							</div>
						</form>
					</div>
					<div class="modal-footer">
						<button type="button" class="btn btn-default" data-dismiss="modal">关闭</button>
						<button type="button" class="btn btn-primary" id="confirmUpdateBtn">更新</button>
					</div>
				</div>
			</div>
		</div>

		<!-- 导入市场活动的模态窗口 -->
		<div class="modal fade" id="importActivityModal" role="dialog">
			<div class="modal-dialog" role="document" style="width: 85%;">
				<div class="modal-content">
					<div class="modal-header">
						<button type="button" class="close" data-dismiss="modal">
							<span aria-hidden="true">×</span>
						</button>
						<h4 class="modal-title" id="myModalLabel">导入市场活动</h4>
					</div>
					<div class="modal-body" style="height: 350px;">
						<div style="position: relative;top: 20px; left: 50px;">
							请选择要上传的文件：<small style="color: gray;">[仅支持.xls]</small>
						</div>
						<div style="position: relative;top: 40px; left: 50px;">
							<input type="file" id="activityFile">
						</div>
						<div style="position: relative; width: 400px; height: 320px; left: 45% ; top: -40px;">
							<h3>重要提示</h3>
							<ul>
								<li>操作仅针对Excel，仅支持后缀名为XLS的文件。</li>
								<li>给定文件的第一行将视为字段名。</li>
								<li>请确认您的文件大小不超过5MB。</li>
								<li>日期值以文本形式保存，必须符合yyyy-MM-dd格式。</li>
								<li>日期时间以文本形式保存，必须符合yyyy-MM-dd HH:mm:ss的格式。</li>
								<li>默认情况下，字符编码是UTF-8 (统一码)，请确保您导入的文件使用的是正确的字符编码方式。
								</li>
								<li>建议您在导入真实数据之前用测试文件测试文件导入功能。</li>
							</ul>
						</div>
					</div>
					<div class="modal-footer">
						<button type="button" class="btn btn-default" data-dismiss="modal">关闭</button>
						<button id="importActivityBtn" type="button" class="btn btn-primary">导入</button>
					</div>
				</div>
			</div>
		</div>

		<!-- 标题 -->
		<div>
			<div style="position: relative; left: 10px; top: -10px;">
				<div class="page-header">
					<h3>市场活动列表</h3>
				</div>
			</div>
		</div>
		<div style="position: relative; top: -20px; left: 0px; width: 100%; height: 100%;">
			<div style="width: 100%; position: absolute;top: 5px; left: 10px;">
				<!-- 查询 -->
				<div class="btn-toolbar" role="toolbar" style="height: 80px;">
					<form class="form-inline" role="form" style="position: relative;top: 8%; left: 5px;">
						<div class="form-group">
							<div class="input-group">
								<div class="input-group-addon">名称</div>
								<input class="form-control" type="text" id="query-name">
							</div>
						</div>
						<div class="form-group">
							<div class="input-group">
								<div class="input-group-addon">所有者</div>
								<input class="form-control" type="text" id="query-owner">
							</div>
						</div>
						<div class="form-group">
							<div class="input-group">
								<div class="input-group-addon">开始日期</div>
								<input class="form-control queryDate" type="text" id="query-startDate" readonly/>
							</div>
						</div>
						<div class="form-group">
							<div class="input-group">
								<div class="input-group-addon">结束日期</div>
								<input class="form-control queryDate" type="text" id="query-endDate" readonly>
							</div>
						</div>

						<button type="button" class="btn btn-default" id="queryBtn">查询</button>

					</form>
				</div>

				<!-- 功能区(创建、修改、删除、上传...) -->
				<div class="btn-toolbar" role="toolbar"
					 style="background-color: #F7F7F7; height: 50px; position: relative;top: 5px;">
					<div class="btn-group" style="position: relative; top: 18%;">
						<button id="createActivityBtn" type="button" class="btn btn-primary">
							<span class="glyphicon glyphicon-plus"></span> 创建
						</button>
						<button id="updateBtn" type="button" class="btn btn-default">
							<span class="glyphicon glyphicon-pencil"></span> 修改
						</button>
						<button id="deleteBtn" type="button" class="btn btn-danger"><span
								class="glyphicon glyphicon-minus"></span> 删除
						</button>
					</div>
					<div class="btn-group" style="position: relative; top: 18%;">
						<button type="button" class="btn btn-default" data-toggle="modal"
								data-target="#importActivityModal"><span class="glyphicon glyphicon-import"></span>
							上传列表数据（导入）
						</button>
						<button id="exportActivityAllBtn" type="button" class="btn btn-default"><span
								class="glyphicon glyphicon-export"></span> 下载列表数据（批量导出）
						</button>
						<button id="exportActivityXzBtn" type="button" class="btn btn-default"><span
								class="glyphicon glyphicon-export"></span> 下载列表数据（选择导出）
						</button>
					</div>
				</div>

				<!-- 活动列表 -->
				<div style="position: relative;top: 10px;">
					<table class="table table-hover">
						<thead>
							<tr style="color: #B3B3B3;">
								<td><input id="checkAll" type="checkbox"/></td>
								<td>名称</td>
								<td>所有者</td>
								<td>开始日期</td>
								<td>结束日期</td>
							</tr>
						</thead>
						<!-- tbody显示活动列表 -->
						<tbody id="tBody"></tbody>
					</table>
				</div>

				<!-- 分页导航 -->
				<div id="activityPage" style="height: 50px; position: relative;top: 30px;">

					<%-- <div>
						<button type="button" class="btn btn-default" style="cursor: default;">共<b id="countB">50</b>条记录
						</button>
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