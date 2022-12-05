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
		<script type="text/javascript" src="jquery/jquery-1.11.1-min.js"></script>
		<script type="text/javascript" src="jquery/bootstrap_3.3.0/js/bootstrap.min.js"></script>

		<script type="text/javascript">

            //默认情况下取消和保存按钮是隐藏的
            var cancelAndSaveBtnDefault = true;

            $(function () {
                $("#remark").focus(function () {
                    if (cancelAndSaveBtnDefault) {
                        //设置remarkDiv的高度为130px
                        $("#remarkDiv").css("height", "130px");
                        //显示
                        $("#cancelAndSaveBtn").show("2000");
                        cancelAndSaveBtnDefault = false;
                    }
                });

                $("#cancelBtn").click(function () {
                    //显示
                    $("#cancelAndSaveBtn").hide();
                    //设置remarkDiv的高度为130px
                    $("#remarkDiv").css("height", "90px");
                    cancelAndSaveBtnDefault = true;
                });

                $(".remarkDiv").mouseover(function () {
                    $(this).children("div").children("div").show();
                });

                $(".remarkDiv").mouseout(function () {
                    $(this).children("div").children("div").hide();
                });

                $(".myHref").mouseover(function () {
                    $(this).children("span").css("color", "red");
                });

                $(".myHref").mouseout(function () {
                    $(this).children("span").css("color", "#E6E6E6");
                });

                <!-- 新建评论"保存"按钮单击事件 -->
                $("#saveCreateRemarkBtn").click(function () {
                    var noteContent = $.trim($("#remark").val());
                    var activityId = $("#activityId").val();
                    if (noteContent == "") {
                        alert("请输入内容...");
                        return;
                    }
                    $.ajax({
                        url: 'workbench/activity/saveCreateActivityRemark.do',
                        data: {
                            noteContent: noteContent,
                            editFlag: 0,//新建则置为0,表示未修改过
                            activityId: activityId
                        },
                        type: 'post',
                        dataType: 'json',
                        success: function (data) {
                            if (data.code == "1") {
                                // $("#remark").val("");
                                //其实应该用内容拼接,但是代码太冗杂了,这里暂时没有实现,而是用页面刷新
                                window.location.href = "workbench/activity/detailOfActivity.do?activityId=" + activityId;
                            } else {
                                alert(data.message);
                            }
                        }
                    });
                });

                <!-- "删除"图标单击事件 -->
                $("#remarkListDiv").on("click", "a[name='deleteA']", function () {
                    var remarkId = $(this).attr("remarkId");	//自定义标签这样获取  dom对象获取jquery对象
                    $.ajax({
                        url: 'workbench/activity/saveDeleteActivityRemark.do',
                        data: {
                            remarkId: remarkId
                        },
                        type: 'post',
                        dataType: 'json',
                        success: function (data) {
                            if (data.code == 1) {
                                $("#div_" + remarkId).remove();
                                // window.location.href = "workbench/activity/detailOfActivity.do?activityId=" + $("#activityId").val();//避免服务器压力
                            } else {
                                alert(data.message);
                            }
                        }
                    });
                });

                <!-- "修改"图标单击事件--模态窗口 -->
                $("#remarkListDiv").on("click", "a[name='editA']", function () {
                    var remarkId = $(this).attr("remarkId");
                    var noteContent = $("#h_" + remarkId).text();
                    $("#remarkId").val(remarkId);
                    $("#noteContent").val(noteContent);
                    $("#editRemarkModal").modal("show");
                });

                <!-- 修改"更新"按钮单击事件 -->
                $("#updateRemarkBtn").click(function () {
                    var remarkId = $("#remarkId").val();
                    var noteContent = $.trim($("#noteContent").val());
                    if (noteContent == "") {
                        alert("内容不为空");
                        return;
                    }
                    $.ajax({
                        url: 'workbench/activity/saveEditActivityRemark.do',
                        data: {
                            id: remarkId,
                            noteContent: noteContent,
                            editFlag: 1//修改则置为1,表示修改过
                        },
                        type: 'post',
                        dataType: 'json',
                        success: function (data) {
                            if (data.code == 1) {
                                $("#h_" + remarkId).text(data.retData.noteContent);
                                var smallContent = "" + data.retData.editTime + " 由" + data.retData.editBy + "修改";
                                $("#small_" + remarkId).text(smallContent);
                                $("#editRemarkModal").modal("hide");
                            } else {
                                alert(data.message);
                                $("#editRemarkModal").modal("show");
                            }
                        }
                    });
                });
            });

		</script>

	</head>
	<body>

		<!-- 修改市场活动备注的模态窗口 -->
		<div class="modal fade" id="editRemarkModal" role="dialog">
			<%-- 备注的id --%>
			<input type="hidden" id="remarkId">
			<div class="modal-dialog" role="document" style="width: 40%;">
				<div class="modal-content">
					<div class="modal-header">
						<button type="button" class="close" data-dismiss="modal">
							<span aria-hidden="true">×</span>
						</button>
						<h4 class="modal-title" id="myModalLabel">修改备注</h4>
					</div>
					<div class="modal-body">
						<form class="form-horizontal" role="form">
							<div class="form-group">
								<label for="noteContent" class="col-sm-2 control-label">内容</label>
								<div class="col-sm-10" style="width: 81%;">
									<textarea class="form-control" rows="3" id="noteContent"></textarea>
								</div>
							</div>
						</form>
					</div>
					<div class="modal-footer">
						<button type="button" class="btn btn-default" data-dismiss="modal">关闭</button>
						<button type="button" class="btn btn-primary" id="updateRemarkBtn">更新</button>
					</div>
				</div>
			</div>
		</div>


		<!-- 返回按钮 -->
		<div style="position: relative; top: 35px; left: 10px;">
			<a href="javascript:void(0);" onclick="window.history.back();"><span class="glyphicon glyphicon-arrow-left"
																				 style="font-size: 20px; color: #DDDDDD"></span></a>
		</div>

		<!-- 大标题 -->
		<div style="position: relative; left: 40px; top: -30px;">
			<div class="page-header">
				<h3>市场活动-${activity.name} <small>${activity.startDate} ~ ${activity.endDate}</small></h3>
			</div>
		</div>

		<br/><br/><br/>

		<!-- 详细信息 -->
		<div style="position: relative; top: -70px;">
			<input id="activityId" type="hidden" value="${activity.id}">
			<div style="position: relative; left: 40px; height: 30px;">
				<div style="width: 300px; color: gray;">所有者</div>
				<div style="width: 300px;position: relative; left: 200px; top: -20px;"><b>${activity.owner}</b></div>
				<div style="width: 300px;position: relative; left: 450px; top: -40px; color: gray;">名称</div>
				<div style="width: 300px;position: relative; left: 650px; top: -60px;"><b>${activity.name}</b></div>
				<div style="height: 1px; width: 400px; background: #D5D5D5; position: relative; top: -60px;"></div>
				<div style="height: 1px; width: 400px; background: #D5D5D5; position: relative; top: -60px; left: 450px;"></div>
			</div>

			<div style="position: relative; left: 40px; height: 30px; top: 10px;">
				<div style="width: 300px; color: gray;">开始日期</div>
				<div style="width: 300px;position: relative; left: 200px; top: -20px;"><b>${activity.startDate}</b>
				</div>
				<div style="width: 300px;position: relative; left: 450px; top: -40px; color: gray;">结束日期</div>
				<div style="width: 300px;position: relative; left: 650px; top: -60px;"><b>${activity.endDate}</b></div>
				<div style="height: 1px; width: 400px; background: #D5D5D5; position: relative; top: -60px;"></div>
				<div style="height: 1px; width: 400px; background: #D5D5D5; position: relative; top: -60px; left: 450px;"></div>
			</div>
			<div style="position: relative; left: 40px; height: 30px; top: 20px;">
				<div style="width: 300px; color: gray;">成本</div>
				<div style="width: 300px;position: relative; left: 200px; top: -20px;"><b>${activity.cost}</b></div>
				<div style="height: 1px; width: 400px; background: #D5D5D5; position: relative; top: -20px;"></div>
			</div>
			<div style="position: relative; left: 40px; height: 30px; top: 30px;">
				<div style="width: 300px; color: gray;">创建者</div>
				<div style="width: 500px;position: relative; left: 200px; top: -20px;">
					<b>${activity.createBy}&nbsp;&nbsp;</b>
					<small style="font-size: 10px; color: gray;">${activity.createTime}</small>
				</div>
				<div style="height: 1px; width: 550px; background: #D5D5D5; position: relative; top: -20px;"></div>
			</div>
			<div style="position: relative; left: 40px; height: 30px; top: 40px;">
				<div style="width: 300px; color: gray;">修改者</div>
				<div style="width: 500px;position: relative; left: 200px; top: -20px;">
					<b>${activity.editBy}&nbsp;&nbsp;</b><small
						style="font-size: 10px; color: gray;">${activity.editTime}</small></div>
				<div style="height: 1px; width: 550px; background: #D5D5D5; position: relative; top: -20px;"></div>
			</div>
			<div style="position: relative; left: 40px; height: 30px; top: 50px;">
				<div style="width: 300px; color: gray;">描述</div>
				<div style="width: 630px;position: relative; left: 200px; top: -20px;">
					<b>
						${activity.description}
					</b>
				</div>
				<div style="height: 1px; width: 850px; background: #D5D5D5; position: relative; top: -20px;"></div>
			</div>
		</div>

		<!-- 备注 -->
		<div id="remarkListDiv" style="position: relative; top: 30px; left: 40px;">
			<div class="page-header">
				<h4>备注</h4>
			</div>

			<!-- 遍历显示备注列表 -->
			<c:forEach items="${activityRemarkList}" var="remark">
				<div id="div_${remark.id}" class="remarkDiv" style="height: 60px;">
					<img title="${remark.createBy}" src="image/user-thumbnail.png"
						 style="width: 30px; height:30px;">
					<div style="position: relative; top: -40px; left: 40px;">
						<h5 id="h_${remark.id}">${remark.noteContent}</h5>
						<font color="gray">市场活动</font> <font color="gray">-</font> <b>${activity.name}</b>
						<small id="small_${remark.id}" style="color: gray;">
							<c:if test="${remark.editFlag eq 0}">${remark.createTime} 由${remark.createBy}创建</c:if>
							<c:if test="${remark.editFlag eq 1}">${remark.editTime} 由${remark.editBy}修改</c:if>
						</small>
						<div style="position: relative; left: 500px; top: -30px; height: 30px; width: 100px; display: none;">
								<%-- 自定义属性remarkId		获取自定义属性的值: jquery对象.attr("属性名")    value属性则为: dom对象.value --%>
							<a class="myHref" name="editA" remarkId="${remark.id}" href="javascript:void(0);">
								<span class="glyphicon glyphicon-edit" style="font-size: 20px; color: #E6E6E6;"></span>
							</a>&nbsp;&nbsp;&nbsp;&nbsp;
							<a class="myHref" name="deleteA" remarkId="${remark.id}" href="javascript:void(0);">
								<span class="glyphicon glyphicon-remove"
									  style="font-size: 20px; color: #E6E6E6;"></span>
							</a>
						</div>
					</div>
				</div>
			</c:forEach>

			<!-- 备注1 -->
			<%-- <div class="remarkDiv" style="height: 60px;">
				<img title="zhangsan" src="image/user-thumbnail.png" style="width: 30px; height:30px;">
				<div style="position: relative; top: -40px; left: 40px;">
					<h5>${activityRemarkList.noteContent}</h5>
					<font color="gray">市场活动</font> <font color="gray">-</font> <b>${activity.name}</b> <small
						style="color: gray;"> ${activityRemarkList.createTime} 由${activityRemarkList.createBy}</small>
					<div style="position: relative; left: 500px; top: -30px; height: 30px; width: 100px; display: none;">
						<a class="myHref" href="javascript:void(0);"><span class="glyphicon glyphicon-edit"
																		   style="font-size: 20px; color: #E6E6E6;"></span></a>
						&nbsp;&nbsp;&nbsp;&nbsp;
						<a class="myHref" href="javascript:void(0);"><span class="glyphicon glyphicon-remove"
																		   style="font-size: 20px; color: #E6E6E6;"></span></a>
					</div>
				</div>
			</div> --%>

			<!-- 备注2 -->
			<%-- <div class="remarkDiv" style="height: 60px;">
				<img title="zhangsan" src="image/user-thumbnail.png" style="width: 30px; height:30px;">
				<div style="position: relative; top: -40px; left: 40px;">
					<h5>${activityRemarkList.noteContent}</h5>
					<font color="gray">市场活动</font> <font color="gray">-</font> <b>${activity.name}</b> <small
						style="color: gray;"> ${activityRemarkList.createTime} 由${activityRemarkList.createBy}</small>
					<div style="position: relative; left: 500px; top: -30px; height: 30px; width: 100px; display: none;">
						<a class="myHref" href="javascript:void(0);"><span class="glyphicon glyphicon-edit"
																		   style="font-size: 20px; color: #E6E6E6;"></span></a>
						&nbsp;&nbsp;&nbsp;&nbsp;
						<a class="myHref" href="javascript:void(0);"><span class="glyphicon glyphicon-remove"
																		   style="font-size: 20px; color: #E6E6E6;"></span></a>
					</div>
				</div>
			</div> --%>

			<div id="remarkDiv" style="background-color: #E6E6E6; width: 870px; height: 90px;">
				<form role="form" style="position: relative;top: 10px; left: 10px;">
                    <textarea id="remark" class="form-control" style="width: 850px; resize : none;" rows="2"
							  placeholder="添加备注..."></textarea>
					<p id="cancelAndSaveBtn" style="position: relative;left: 737px; top: 10px; display: none;">
						<button id="cancelBtn" type="button" class="btn btn-default">取消</button>
						<button id="saveCreateRemarkBtn" type="button" class="btn btn-primary">保存</button>
					</p>
				</form>
			</div>
		</div>
		<div style="height: 200px;"></div>
	</body>
</html>