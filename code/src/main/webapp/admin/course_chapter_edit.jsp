<%@ page language="java" contentType="text/html; charset=UTF-8"
         pageEncoding="UTF-8" %>
<%
    String BASE = request.getScheme() + "://" + request.getServerName() + ":" + request.getServerPort()
            + request.getContextPath() + "/";
    String PATH = request.getContextPath();
    String SPATH = PATH + "/static";
    String LPATH = SPATH + "/lib";
    String TPATH = SPATH + "/theme";
    String TDPATH = TPATH + "/default";
%>
<style>
    .layui-input-block {
        margin-right: 40px;
    }
</style>
<div class="content" style="margin-top: 40px">
    <link rel="stylesheet" href="<%=PATH%>/assets/layui/css/layui.css">
    <script src="<%=PATH%>/assets/js/jquery-3.2.1.js"></script>
    <form class="layui-form" action="" id="chapter-edit-form">
        <input type="hidden" name="chapter_id"
               class="layui-input" value="${detail.chapter_id}">
		<div class="layui-form-item">
			<label class="layui-form-label">所属课程</label>
			<div class="layui-input-block">
				<select name="course_id" lay-verify="required">

				</select>
			</div>
		</div>
		<div class="layui-form-item">
            <label class="layui-form-label">标题</label>
            <div class="layui-input-block">
                <input type="text" name="chapter_name" required lay-verify="required"
                       placeholder="请输入章标题" autocomplete="off" class="layui-input" value="${detail.chapter_name}">
            </div>
        </div>
        <div class="layui-form-item">
            <label class="layui-form-label">封面</label>
            <input type="hidden" name="chapter_head"
                   class="layui-input" value="${detail.chapter_head}">
            <div class="layui-upload" style="margin-left: 110px;">
                <button type="button" class="layui-btn" id="chapter-edit-form-file-commit">上传图片</button>
                <div class="layui-upload-list">
                    <img class="layui-upload-img" id="chapter-edit-form-file-img-preview"
                         style="width: 150px;height: 150px;">
                    <p id="chapter-edit-form-file-text"></p>
                </div>
            </div>
        </div>

        <div class="layui-form-item">
            <div class="layui-input-block">
                <button class="layui-btn" lay-submit
                        lay-filter="chapter-edit-form-commit">立即提交
                </button>
                <button type="reset" class="layui-btn layui-btn-primary">重置</button>
            </div>
        </div>
    </form>
</div>

<script src="<%=PATH%>/assets/layui/layui.js"></script>
<script>
    (function ($) {
        layui.use(['form', 'upload'], function () {
            var form = layui.form
                , upload = layui.upload;

            //监听提交
            form.on('submit(chapter-edit-form-commit)', function (data) {
                $.ajax({
                    url: 'edit.do',
                    data: data.field,
                    type: 'post',
                    success: function (result) {
                        if (result.success) {
                            layer.msg(result.msg || '保存成功');
                            var index = parent.layer.getFrameIndex(window.name); //先得到当前iframe层的索引
                            parent.layer.close(index);
                        } else {
                            layer.msg(result.msg || '保存失败');
                        }
                    }
                });
                return false;
            });
            if ('${detail.chapter_head}' != undefined) {
                $('#chapter-edit-form-file-img-preview').attr('src', '<%=PATH%>/' + '${detail.chapter_head}');
            }

            //上传文件
            var uploadInst = upload.render({
                elem: '#chapter-edit-form-file-commit' //绑定元素
                , field: 'img'
                , url: '<%=PATH%>/file/upload.do' //上传接口
                , before: function (obj) {
                    //预读本地文件示例，不支持ie8
                    obj.preview(function (index, file, result) {
                        $('#chapter-edit-form-file-img-preview').attr('src', result); //图片链接（base64）
                    });
                }
                , done: function (res) {
                    if (res.success) {
                        $('input[name="chapter_head"]').val(res.msg);
                    } else {
                        layer.msg('上传失败');
                    }
                }
                , error: function () {
                    //演示失败状态，并实现重传
                    var demoText = $('#chapter-edit-form-file-text');
                    demoText.html('<span style="color: #FF5722;">上传失败</span> <a class="layui-btn layui-btn-sm demo-reload">重试</a>');
                    demoText.find('.demo-reload').on('click', function () {
                        uploadInst.upload();
                    });
                }
            });


			//加载课程列表
			$.ajax({
				url: '<%=PATH%>/course/queryList.do',
				data: {},
				type: 'post',
				success: function (result) {
					if (result.success) {
						var html = '';
						$.each(result.data, function (i, o) {
							html += '<option value="' + o.course_id + '">' + o.course_name + '</option>';
						});
						$('select[name="course_id"]').html(html);
						$('select[name="course_id"]').val('${detail.course_id}');

					}
					form.render('select');
				}
			});




		});

    })(window.jQuery);
</script>