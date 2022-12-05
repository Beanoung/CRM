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
		<link href="jquery/bootstrap-datetimepicker-master/css/bootstrap-datetimepicker.min.css" type="text/css"
			  rel="stylesheet"/>
		<link href="jquery/bs_pagination-master/css/jquery.bs_pagination.min.css" type="text/css" rel="stylesheet"/>

		<script type="text/javascript" src="jquery/jquery-1.11.1-min.js"></script>
		<script type="text/javascript" src="jquery/bootstrap_3.3.0/js/bootstrap.min.js"></script>
		<script type="text/javascript"
				src="jquery/bootstrap-datetimepicker-master/js/bootstrap-datetimepicker.js"></script>
		<script type="text/javascript"
				src="jquery/bootstrap-datetimepicker-master/locale/bootstrap-datetimepicker.zh-CN.js"></script>
		<script type="text/javascript" src="jquery/bs_pagination-master/js/jquery.bs_pagination.min.js"></script>
		<script type="text/javascript" src="jquery/bs_pagination-master/localization/en.js"></script>

		<script type="text/javascript">

            $(function () {
                <!-- "创建"按钮单击事件 -->
                $("#createClueBtn").click(function () {
                    //重置表单
                    $("#createClueForm").get(0).reset();
                    $("#createClueModal").modal("show");
                });

                <!-- 日历 -->
                $("#create-nextContactTime,#edit-nextContactTime").datetimepicker({
                    language: 'zh-CN',
                    format: 'yyyy-mm-dd',
                    minView: 'month',
                    initialDate: new Date(),
                    autoclose: true,
                    todayBtn: true,
                    clearBtn: true,
                    pickerPosition: 'top-right'
                });

                <!-- 创建线索"保存"按钮单击事件 -->
                $("#saveCreateClueBtn").click(function () {
                    //收集参数
                    var owner = $("#create-clueOwner").val();
                    var company = $.trim($("#create-company").val());
                    var call = $("#create-call").val();
                    var surname = $.trim($("#create-surname").val());
                    var job = $.trim($("#create-job").val());
                    var email = $.trim($("#create-email").val());
                    var phone = $.trim($("#create-phone").val());
                    var website = $.trim($("#create-website").val());
                    var mphone = $.trim($("#create-mphone").val());
                    var status = $("#create-status").val();
                    var source = $("#create-source").val();
                    var describe = $.trim($("#create-describe").val());
                    var contactSummary = $.trim($("#create-contactSummary").val());
                    var nextContactTime = $("#create-nextContactTime").val();
                    var address = $.trim($("#create-address").val());

                    // 预留: 数据验证

                    $.ajax({
                        url: 'workbench/clue/saveCreateClue.do',
                        data: {
                            owner: owner,
                            company: company,
                            appellation: call,
                            fullname: surname,
                            job: job,
                            email: email,
                            phone: phone,
                            website: website,
                            mphone: mphone,
                            state: status,
                            source: source,
                            description: describe,
                            contactSummary: contactSummary,
                            nextContactTime: nextContactTime,
                            address: address
                        },
                        type: 'post',
                        dataType: 'json',
                        success: function (data) {
                            if (data.code == "1") {
                                queryClueByConditionForPage(1, $("#cluePage").bs_pagination('getOption', 'rowsPerPage'))
                                $("#createClueModal").modal("hide");
                            } else {
                                alert(data.message);
                                $("#createClueModal").modal("show");
                            }
                        }
                    });
                });

                <!-- 加载页面列表 -->
                queryClueByConditionForPage(1, 5);

                <!-- "查询"按钮单击事件 -->
                $("#queryBtn").click(function () {
                    queryClueByConditionForPage(1, $("#cluePage").bs_pagination("getOption", "rowsPerPage"))
                });

                <!-- "修改"按钮单击事件 -->
                $("#updateBtn").click(function () {
                    var checkedId = $("#tBody input[type='checkbox']:checked");
                    if (checkedId.size() > 1 || checkedId.size() == 0) {
                        alert("请选择一个线索");
                        return;
                    }
                    var id = checkedId.val();
                    $.ajax({
                        url: 'workbench/clue/queryClueById.do',
                        data: {
                            id: id
                        },
                        type: 'post',
                        dataType: 'json',
                        success: function (data) {
                            $("#clueID").val(data.id);
                            $("#edit-clueOwner").val(data.owner);
                            $("#edit-company").val(data.company);
                            $("#edit-call").val(data.appellation);
                            $("#edit-surname").val(data.fullname);
                            $("#edit-job").val(data.job);
                            $("#edit-email").val(data.email);
                            $("#edit-phone").val(data.phone);
                            $("#edit-website").val(data.website);
                            $("#edit-mphone").val(data.mphone);
                            $("#edit-status").val(data.state);
                            $("#edit-source").val(data.source);
                            $("#edit-describe").val(data.description);
                            $("#edit-contactSummary").val(data.contactSummary);
                            $("#edit-nextContactTime").val(data.nextContactTime);
                            $("#edit-address").val(data.address);
                        }
                    });
                    $("#editClueModal").modal("show");
                });

                <!-- 修改线索"更新"按钮单击事件 -->
                $("#saveUpdateBtn").click(function () {
                    var id = $("#clueID").val();
                    var owner = $("#edit-clueOwner").val();
                    var company = $.trim($("#edit-company").val());
                    var appellation = $("#edit-call").val();
                    var fullname = $.trim($("#edit-surname").val());
                    var job = $.trim($("#edit-job").val());
                    var email = $.trim($("#edit-email").val());
                    var phone = $.trim($("#edit-phone").val());
                    var website = $.trim($("#edit-website").val());
                    var mphone = $.trim($("#edit-mphone").val());
                    var state = $("#edit-status").val();
                    var source = $("#edit-source").val();
                    var description = $.trim($("#edit-describe").val());
                    var contactSummary = $.trim($("#edit-contactSummary").val());
                    var nextContactTime = $("#edit-nextContactTime").val();
                    var address = $.trim($("#edit-address").val());

                    $.ajax({
                        url: 'workbench/clue/saveEditClue.do',
                        data: {
                            id: id,
                            owner: owner,
                            company: company,
                            appellation: appellation,
                            fullname: fullname,
                            job: job,
                            email: email,
                            phone: phone,
                            website: website,
                            mphone: mphone,
                            state: state,
                            source: source,
                            description: description,
                            contactSummary: contactSummary,
                            nextContactTime: nextContactTime,
                            address: address
                        },
                        type: 'post',
                        dataType: 'json',
                        success: function (data) {
                            if (data.code == "1") {
                                $("#editClueModal").modal("hide");
                                queryClueByConditionForPage(
                                    $("#cluePage").bs_pagination('getOption', 'currentPage'),
									$("#cluePage").bs_pagination('getOption', 'rowsPerPage'));
                            } else {
                                alert(data.message);
                                $("#editClueModal").modal("show");
                            }
                        }
                    });
                });

                <!-- "全选"checkbox单击事件 -->
                $("#checkAll").click(function () {
                    $("#tBody input[type='checkbox']").prop("checked", this.checked);
                });

                <!-- "单选"checkbox单击事件 -->
                $("#tBody").on("click", "input[type='checkbox']", function () {
                    if ($("#tBody input[type='checkbox']").size() == $("#tBody input[type='checkbox']:checked").size()) {
                        $("#checkAll").prop("checked", true);
                    } else {
                        $("#checkAll").prop("checked", false);
                    }
                });

                <!-- "删除"按钮单击事件 -->
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
                    $.ajax({
                        url: 'workbench/clue/saveDeleteClueByIds.do',
                        data: ids,
                        type: 'post',
                        dataType: 'json',
                        success: function (data) {
                            if (data.code == 1) {
                                alert("成功删除" + data.retData + "条记录");
                                queryClueByConditionForPage(
                                    $("#cluePage").bs_pagination('getOption', 'currentPage'),
									$("#cluePage").bs_pagination("getOption", "rowsPerPage"));
                            } else {
                                alert(data.message);
                            }
                        }
                    });
                });

            });

            <!-- 函数: 根据条件查询线索列表并分页 -->
            function queryClueByConditionForPage(pageNo, pageSize) {
                var fullname = $("#query-fullname").val();
                var company = $("#query-company").val();
                var phone = $("#query-phone").val();
                var source = $("#query-source").val();
                var owner = $("#query-owner").val();
                var mphone = $("#query-mphone").val();
                var state = $("#query-status").val();

                // 预留: 数据验证

                $.ajax({
                    url: 'workbench/clue/queryClueByConditionForPage.do',
                    data: {
                        fullname: fullname,
                        company: company,
                        phone: phone,
                        source: source,
                        owner: owner,
                        mphone: mphone,
                        state: state,
                        pageNo: pageNo,
                        pageSize: pageSize
                    },
                    type: 'post',
                    dataType: 'json',
                    success: function (data) {
                        //显示总条数
                        $("#countB").text(data.count);
                        //遍历显示列表
                        var htmlStr = "";
                        <!-- /为转义符,可以避免改"为' -->
                        $.each(data.clueList, function (index, obj) {
                            htmlStr += "<tr class=\"active\">";
                            htmlStr += "<td><input type=\"checkbox\" value=\"" + obj.id + "\"/></td>";
                            htmlStr += "<td><a style=\"text-decoration: none; cursor: pointer;\" onclick=\"window.location.href='workbench/clue/detailOfClue.do?clueId=" + obj.id + "'\">" + obj.fullname + obj.appellation + "</a></td>";
                            htmlStr += "<td>" + obj.company + "</td>";
                            htmlStr += "<td>" + obj.phone + "</td>";
                            htmlStr += "<td>" + obj.mphone + "</td>";
                            htmlStr += "<td>" + obj.source + "</td>";
                            htmlStr += "<td>" + obj.owner + "</td>";
                            htmlStr += "<td>" + obj.state + "</td>";
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
                        $("#cluePage").bs_pagination({
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
                                queryClueByConditionForPage(pageObj.currentPage, pageObj.rowsPerPage)
                            }
                        });
                    }
                });
            }
		</script>
	</head>
	<body>

		<!-- 创建线索的模态窗口 -->
		<div class="modal fade" id="createClueModal" role="dialog">
			<div class="modal-dialog" role="document" style="width: 90%;">
				<div class="modal-content">
					<div class="modal-header">
						<button type="button" class="close" data-dismiss="modal">
							<span aria-hidden="true">×</span>
						</button>
						<h4 class="modal-title" id="myModalLabel">创建线索</h4>
					</div>
					<!-- 填写数据 -->
					<div class="modal-body">
						<form id="createClueForm" class="form-horizontal" role="form">
							<!-- owner/company -->
							<div class="form-group">
								<label for="create-clueOwner" class="col-sm-2 control-label">所有者<span
										style="font-size: 15px; color: red;">*</span></label>
								<div class="col-sm-10" style="width: 300px;">
									<select class="form-control" id="create-clueOwner">
										<c:forEach items="${userList}" var="user">
											<option value="${user.id}">${user.name}</option>
										</c:forEach>
									</select>
								</div>
								<label for="create-company" class="col-sm-2 control-label">公司<span
										style="font-size: 15px; color: red;">*</span></label>
								<div class="col-sm-10" style="width: 300px;">
									<input type="text" class="form-control" id="create-company">
								</div>
							</div>
							<!-- appellation/fullname -->
							<div class="form-group">
								<label for="create-call" class="col-sm-2 control-label">称呼</label>
								<div class="col-sm-10" style="width: 300px;">
									<select class="form-control" id="create-call">
										<option></option>
										<c:forEach items="${appellationList}" var="appellation">
											<option value="${appellation.id}">${appellation.value}</option>
										</c:forEach>
									</select>
								</div>
								<label for="create-surname" class="col-sm-2 control-label">姓名<span
										style="font-size: 15px; color: red;">*</span></label>
								<div class="col-sm-10" style="width: 300px;">
									<input type="text" class="form-control" id="create-surname">
								</div>
							</div>
							<!-- job/email -->
							<div class="form-group">
								<label for="create-job" class="col-sm-2 control-label">职位</label>
								<div class="col-sm-10" style="width: 300px;">
									<input type="text" class="form-control" id="create-job">
								</div>
								<label for="create-email" class="col-sm-2 control-label">邮箱</label>
								<div class="col-sm-10" style="width: 300px;">
									<input type="text" class="form-control" id="create-email">
								</div>
							</div>
							<!-- phone/website -->
							<div class="form-group">
								<label for="create-phone" class="col-sm-2 control-label">公司座机</label>
								<div class="col-sm-10" style="width: 300px;">
									<input type="text" class="form-control" id="create-phone">
								</div>
								<label for="create-website" class="col-sm-2 control-label">公司网站</label>
								<div class="col-sm-10" style="width: 300px;">
									<input type="text" class="form-control" id="create-website">
								</div>
							</div>
							<!-- mphone/state -->
							<div class="form-group">
								<label for="create-mphone" class="col-sm-2 control-label">手机</label>
								<div class="col-sm-10" style="width: 300px;">
									<input type="text" class="form-control" id="create-mphone">
								</div>
								<label for="create-status" class="col-sm-2 control-label">线索状态</label>
								<div class="col-sm-10" style="width: 300px;">
									<select class="form-control" id="create-status">
										<option></option>
										<c:forEach items="${clueStateList}" var="clueState">
											<option value="${clueState.id}">${clueState.value}</option>
										</c:forEach>
									</select>
								</div>
							</div>
							<!-- source -->
							<div class="form-group">
								<label for="create-source" class="col-sm-2 control-label">线索来源</label>
								<div class="col-sm-10" style="width: 300px;">
									<select class="form-control" id="create-source">
										<option></option>
										<c:forEach items="${sourceList}" var="source">
											<option value="${source.id}">${source.value}</option>
										</c:forEach>
									</select>
								</div>
							</div>
							<!-- description -->
							<div class="form-group">
								<label for="create-describe" class="col-sm-2 control-label">线索描述</label>
								<div class="col-sm-10" style="width: 81%;">
									<textarea class="form-control" rows="3" id="create-describe"></textarea>
								</div>
							</div>
							<div style="height: 1px; width: 103%; background-color: #D5D5D5; left: -13px; position: relative;"></div>
							<!-- contact_summary/next_contact_time -->
							<div style="position: relative;top: 15px;">
								<div class="form-group">
									<label for="create-contactSummary" class="col-sm-2 control-label">联系纪要</label>
									<div class="col-sm-10" style="width: 81%;">
										<textarea class="form-control" rows="3" id="create-contactSummary"></textarea>
									</div>
								</div>
								<div class="form-group">
									<label for="create-nextContactTime"
										   class="col-sm-2 control-label">下次联系时间</label>
									<div class="col-sm-10" style="width: 300px;">
										<input type="text" class="form-control" id="create-nextContactTime" readonly>
									</div>
								</div>
							</div>
							<div style="height: 1px; width: 103%; background-color: #D5D5D5; left: -13px; position: relative; top : 10px;"></div>
							<!-- address -->
							<div style="position: relative;top: 20px;">
								<div class="form-group">
									<label for="create-address" class="col-sm-2 control-label">详细地址</label>
									<div class="col-sm-10" style="width: 81%;">
										<textarea class="form-control" rows="1" id="create-address"></textarea>
									</div>
								</div>
							</div>
						</form>
					</div>
					<!-- 关闭/保存 -->
					<div class="modal-footer">
						<button type="button" class="btn btn-default" data-dismiss="modal">关闭</button>
						<button id="saveCreateClueBtn" type="button" class="btn btn-primary" data-dismiss="modal">保存
						</button>
					</div>
				</div>
			</div>
		</div>

		<!-- 修改线索的模态窗口 -->
		<div class="modal fade" id="editClueModal" role="dialog">
			<div class="modal-dialog" role="document" style="width: 90%;">
				<div class="modal-content">
					<div class="modal-header">
						<button type="button" class="close" data-dismiss="modal">
							<span aria-hidden="true">×</span>
						</button>
						<h4 class="modal-title">修改线索</h4>
					</div>
					<div class="modal-body">
						<form class="form-horizontal" role="form">
							<input type="hidden" id="clueID">
							<div class="form-group">
								<label for="edit-clueOwner" class="col-sm-2 control-label">所有者<span
										style="font-size: 15px; color: red;">*</span></label>
								<div class="col-sm-10" style="width: 300px;">
									<select class="form-control" id="edit-clueOwner">
										<c:forEach items="${userList}" var="user">
											<option value="${user.id}">${user.name}</option>
										</c:forEach>
									</select>
								</div>
								<label for="edit-company" class="col-sm-2 control-label">公司<span
										style="font-size: 15px; color: red;">*</span></label>
								<div class="col-sm-10" style="width: 300px;">
									<input type="text" class="form-control" id="edit-company">
								</div>
							</div>
							<div class="form-group">
								<label for="edit-call" class="col-sm-2 control-label">称呼</label>
								<div class="col-sm-10" style="width: 300px;">
									<select class="form-control" id="edit-call">
										<option></option>
										<c:forEach items="${appellationList}" var="appellation">
											<option value="${appellation.id}">${appellation.value}</option>
										</c:forEach>
									</select>
								</div>
								<label for="edit-surname" class="col-sm-2 control-label">姓名<span
										style="font-size: 15px; color: red;">*</span></label>
								<div class="col-sm-10" style="width: 300px;">
									<input type="text" class="form-control" id="edit-surname">
								</div>
							</div>
							<div class="form-group">
								<label for="edit-job" class="col-sm-2 control-label">职位</label>
								<div class="col-sm-10" style="width: 300px;">
									<input type="text" class="form-control" id="edit-job">
								</div>
								<label for="edit-email" class="col-sm-2 control-label">邮箱</label>
								<div class="col-sm-10" style="width: 300px;">
									<input type="text" class="form-control" id="edit-email">
								</div>
							</div>
							<div class="form-group">
								<label for="edit-phone" class="col-sm-2 control-label">公司座机</label>
								<div class="col-sm-10" style="width: 300px;">
									<input type="text" class="form-control" id="edit-phone">
								</div>
								<label for="edit-website" class="col-sm-2 control-label">公司网站</label>
								<div class="col-sm-10" style="width: 300px;">
									<input type="text" class="form-control" id="edit-website">
								</div>
							</div>
							<div class="form-group">
								<label for="edit-mphone" class="col-sm-2 control-label">手机</label>
								<div class="col-sm-10" style="width: 300px;">
									<input type="text" class="form-control" id="edit-mphone">
								</div>
								<label for="edit-status" class="col-sm-2 control-label">线索状态</label>
								<div class="col-sm-10" style="width: 300px;">
									<select class="form-control" id="edit-status">
										<option></option>
										<c:forEach items="${clueStateList}" var="clueState">
											<option value="${clueState.id}">${clueState.value}</option>
										</c:forEach>
									</select>
								</div>
							</div>
							<div class="form-group">
								<label for="edit-source" class="col-sm-2 control-label">线索来源</label>
								<div class="col-sm-10" style="width: 300px;">
									<select class="form-control" id="edit-source">
										<option></option>
										<c:forEach items="${sourceList}" var="source">
											<option value="${source.id}">${source.value}</option>
										</c:forEach>
									</select>
								</div>
							</div>
							<div class="form-group">
								<label for="edit-describe" class="col-sm-2 control-label">描述</label>
								<div class="col-sm-10" style="width: 81%;">
									<textarea class="form-control" rows="3" id="edit-describe"></textarea>
								</div>
							</div>
							<div style="height: 1px; width: 103%; background-color: #D5D5D5; left: -13px; position: relative;"></div>
							<div style="position: relative;top: 15px;">
								<div class="form-group">
									<label for="edit-contactSummary" class="col-sm-2 control-label">联系纪要</label>
									<div class="col-sm-10" style="width: 81%;">
										<textarea class="form-control" rows="3" id="edit-contactSummary"></textarea>
									</div>
								</div>
								<div class="form-group">
									<label for="edit-nextContactTime"
										   class="col-sm-2 control-label">下次联系时间</label>
									<div class="col-sm-10" style="width: 300px;">
										<input type="text" class="form-control" id="edit-nextContactTime" readonly>
									</div>
								</div>
							</div>
							<div style="height: 1px; width: 103%; background-color: #D5D5D5; left: -13px; position: relative; top : 10px;"></div>
							<div style="position: relative;top: 20px;">
								<div class="form-group">
									<label for="edit-address" class="col-sm-2 control-label">详细地址</label>
									<div class="col-sm-10" style="width: 81%;">
										<textarea class="form-control" rows="1" id="edit-address"></textarea>
									</div>
								</div>
							</div>
						</form>
					</div>
					<div class="modal-footer">
						<button type="button" class="btn btn-default" data-dismiss="modal">关闭</button>
						<button id="saveUpdateBtn" type="button" class="btn btn-primary" data-dismiss="modal">更新
						</button>
					</div>
				</div>
			</div>
		</div>

		<!-- 标题 -->
		<div>
			<div style="position: relative; left: 10px; top: -10px;">
				<div class="page-header">
					<h3>线索列表</h3>
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
								<input id="query-fullname" class="form-control" type="text">
							</div>
						</div>
						<div class="form-group">
							<div class="input-group">
								<div class="input-group-addon">公司</div>
								<input id="query-company" class="form-control" type="text">
							</div>
						</div>
						<div class="form-group">
							<div class="input-group">
								<div class="input-group-addon">公司座机</div>
								<input id="query-phone" class="form-control" type="text">
							</div>
						</div>
						<div class="form-group">
							<div class="input-group">
								<div class="input-group-addon">线索来源</div>
								<select id="query-source" class="form-control">
									<option></option>
									<c:forEach items="${sourceList}" var="source">
										<option value="${source.id}">${source.value}</option>
									</c:forEach>
								</select>
							</div>
						</div>
						<br>
						<div class="form-group">
							<div class="input-group">
								<div class="input-group-addon">所有者</div>
								<select id="query-owner" class="form-control">
									<option></option>
									<c:forEach items="${userList}" var="user">
										<option value="${user.id}">${user.name}</option>
									</c:forEach>
								</select>
							</div>
						</div>
						<div class="form-group">
							<div class="input-group">
								<div class="input-group-addon">手机</div>
								<input id="query-mphone" class="form-control" type="text">
							</div>
						</div>
						<div class="form-group">
							<div class="input-group">
								<div class="input-group-addon">线索状态</div>
								<select id="query-status" class="form-control">
									<option></option>
									<c:forEach items="${clueStateList}" var="clueState">
										<option value="${clueState.id}">${clueState.value}</option>
									</c:forEach>
								</select>
							</div>
						</div>
						<button id="queryBtn" type="button" class="btn btn-default">查询</button>
					</form>
				</div>

				<!-- 增、删、改 -->
				<div class="btn-toolbar" role="toolbar"
					 style="background-color: #F7F7F7; height: 50px; position: relative;top: 40px;">
					<div class="btn-group" style="position: relative; top: 18%;">
						<button id="createClueBtn" type="button" class="btn btn-primary">
							<span class="glyphicon glyphicon-plus"></span> 创建
						</button>
						<button id="updateBtn" type="button" class="btn btn-default">
							<span class="glyphicon glyphicon-pencil"></span> 修改
						</button>
						<button id="deleteBtn" type="button" class="btn btn-danger">
							<span class="glyphicon glyphicon-minus"></span> 删除
						</button>
					</div>
				</div>

				<!-- 线索列表 -->
				<div style="position: relative;top: 50px;">
					<table class="table table-hover">
						<thead>
							<tr style="color: #B3B3B3;">
								<td><input id="checkAll" type="checkbox"/></td>
								<td>名称</td>
								<td>公司</td>
								<td>公司座机</td>
								<td>手机</td>
								<td>线索来源</td>
								<td>所有者</td>
								<td>线索状态</td>
							</tr>
						</thead>
						<tbody id="tBody"></tbody>
					</table>
				</div>

				<!-- 分页导航 -->
				<div id="cluePage" style="height: 50px; position: relative;top: 60px;">
					<%-- <div>
						<button type="button" class="btn btn-default" style="cursor: default;">共<b>50</b>条记录
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
					</div> --%>
				</div>
			</div>
		</div>
	</body>
</html>