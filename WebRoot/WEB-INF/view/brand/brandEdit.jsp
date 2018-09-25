<%@ page language="java" import="java.util.*" pageEncoding="UTF-8"%>
<%@taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>
<%@taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt"%>
<%
String path = request.getContextPath();
String basePath = request.getScheme()+"://"+request.getServerName()+":"+request.getServerPort()+path+"/";
%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0//EN" "http://www.w3.org/TR/html4/strict.dtd">
<html>
  <head>
    <base href="<%=basePath%>">
    <title>品牌编辑</title>
	<meta http-equiv="pragma" content="no-cache">
	<meta http-equiv="cache-control" content="no-cache">
	<meta http-equiv="expires" content="0">    
	<meta http-equiv="keywords" content="keyword1,keyword2,keyword3">
	<meta http-equiv="description" content="This is my page">
	<meta http-equiv="X-UA-Compatible" content="IE=EmulateIE8"/>
	<jsp:include page="/tags.jsp"></jsp:include>
	<script type="text/javascript" charset="utf-8" src="http://<%=request.getServerName()+":"+request.getServerPort() %>/ueditor/ueditor.config.js"></script>
	<script type="text/javascript" charset="utf-8" src="http://<%=request.getServerName()+":"+request.getServerPort() %>/ueditor/ueditor.all.min.js"> </script>
	<!--建议手动加在语言，避免在ie下有时因为加载语言失败导致编辑器加载失败-->
	<!--这里加载的语言文件会覆盖你在配置项目里添加的语言类型，比如你在配置项目里配置的是英文，这里加载的中文，那最后就是中文-->
	<script type="text/javascript" charset="utf-8" src="http://<%=request.getServerName()+":"+request.getServerPort() %>/ueditor/lang/zh-cn/zh-cn.js"></script>
  </head>
  
  <body>
	<script type="text/javascript">
		function saveBrand(){
			var flag = $('#form1').form('validate');
			if(!flag) {
				return false;
			}
			var imgarray=[];
			for(var i=0;i<$(".uploaditem").length;i++){
				var url=$(".uploaditem").eq(i).find("input[type='hidden']").val();
				if(url){
					imgarray.push(url);
				}
			}
			if(imgarray.length<=0){
				$.messager.alert('提示','请上传图片','info');
				return false;
			}
			$("input[name='imgJson']").val(JSON.stringify(imgarray));
			$.post("<%=request.getContextPath()%>/brand/saveBrand.action",$("#form1").serializeArray(),function(data){
				/*$("#dialog").dialog("close");
				$.messager.alert('提示',data,'info');
				searchBrand();*/
				var url="<%=request.getContextPath()%>/brand/initBrandList.action";
				if(window.parent&&parent.closeTabAndOpen){
					parent.closeTabAndOpen("品牌编辑","设计师品牌",url);
				}else{
					location.href=url;
				}
			}); 
		}
		
		function upload(t,obj1,obj2){
			var id=$(t).attr("id");
			$.ajaxFileUpload({
                url: '${ctx}/attachment/uploadFile.action', //用于文件上传的服务器端请求地址
                secureuri: false, //是否需要安全协议，一般设置为false
                fileElementId: id, //文件上传域的ID
                dataType: 'json', //返回值类型 一般设置为json
                success: function (data, status)  //服务器成功响应处理函数
                {
                    $("#"+obj1).attr("src", "${ftppath}"+data.filePath);
                    $("input[name='"+obj2+"']").val(data.filePath);
                },
                error: function (data, status, e)//服务器响应失败处理函数
                {
                    alert(e);
                }
            });
		}
		
		function addUpload(t){
			var i=$(".uploaditem:last").find("input[type='hidden']").attr("name").substring(3);
			if(!i){
				i=1;
			}
			var index=parseInt(i)+1;
			var html="<div class='item uploaditem'>"
			+"<div class='label'>图片:</div>"
			+"<div class='input'>"
			+"<img  onerror='defaultImg(this)' src='${ctx}/images/noimg.jpg' id='img"+index+"' width='90' height='90'/><a href='javascript:void(0)' onclick='removeUpload(this)'><img src='${ctx }/images/remove.png'/></a>"
			+"<input type='file' class='imgupload' name='file1' accept='image/png,image/gif,image/jpg,image/jpeg' onchange=\"upload(this,'img"+index+"','img"+index+"')\" id='typeicon"+index+"'/>"
			+"<input type='hidden' name='img"+index+"' value=''/>"
			+"</div>"
			+"</div>";
			$(t).parent().parent().after(html);
		}
		
		function removeUpload(t){
			$(t).parent().parent().remove();
		}
		
		var ue;
		$(function(){
			if(!ue){
				ue=UE.getEditor('ueditor',{initialFrameWidth :($(window).width()-130),initialFrameHeight :300,wordCount:false});
			}
			ue.ready(function() {
				ue.setContent('${brand.detailintro }');
			});
		});
	</script>
  	<form name="form1" method="post" id="form1" class="l-form">
		<input type="hidden" name="imgJson"/>
		<input type="hidden" name="id" value="${brand.id}"/>
		<div class="title">
			<div class="icon"><img src='<c:url value="/images/info.png"></c:url>' width="20"/></div>
			<span>品牌信息</span>
		</div>
		<div class="formitems">
			<div class="item">
				<div class="label"><span style="color:red">*</span>名称:</div>
				<div class="input">
					<input name="name" type="text" id="name" value="${brand.name}" data-options="required:true,validType:['length[1,50]']" class="easyui-validatebox"/>
				</div>
			</div>
			<div class="item">
				<div class="label"><span style="color:red">*</span>类型:</div>
				<div class="input">
					<label><input type="radio" name="type" <c:if test="${brand.type==null || brand.type=='0' }">checked="checked"</c:if> value="0"/>设计师品牌</label>
					<label><input type="radio" name="type" <c:if test="${brand.type=='1' }">checked="checked"</c:if> value="1"/>联名合作</label>
				</div>
			</div>
			<div class="item">
				<div class="label">排序值:</div>
				<div class="input">
					<input name="sortno" type="text" id="sortno" <c:if test="${brand.id==null }">value="0"</c:if><c:if test="${brand.id!=null }">value="${brand.sortno}"</c:if> data-options="required:true,validType:['number']" class="easyui-validatebox"/>
				</div>
			</div>
			<c:if test="${brand.id==null }">
				<div class="item uploaditem">
					<div class="label">图片:</div>
					<div class="input">
						<img src="${ctx }/images/noimg.jpg" onclick='showImg(this)' onerror="defaultImg(this)" id="img1" width="90" height="90"/><a href="javascript:void(0)" onclick="addUpload(this)"><img src="${ctx }/images/add.png"/></a>
						<input type="file" class="imgupload" name="file1" accept="image/png,image/gif,image/jpg,image/jpeg" onchange="upload(this,'img1','img1')" id="typeicon1"/>
						<input type="hidden" name="img1" value="${brand.img }"/>
					</div>
				</div>
			</c:if>
			<c:if test="${brand.id!=null }">
				<c:forEach items="${imgs }" var="img" varStatus="status">
				<div class="item uploaditem">
					<div class="label">图片:</div>
					<div class="input">
						<img src="${ftppath }${img.path}" onerror="defaultImg(this)" onclick='showImg(this)' id="img${status.index+1}" width="90" height="90"/>
						<c:if test="${status.index==0 }">
						<a href="javascript:void(0)" onclick="addUpload(this)"><img src="${ctx }/images/add.png"/></a>
						</c:if>
						<c:if test="${status.index!=0 }">
						<a href="javascript:void(0)" onclick="removeUpload(this)"><img src="${ctx }/images/remove.png"/></a>
						</c:if>
						<input type="file" class="imgupload" name="file1" accept="image/png,image/gif,image/jpg,image/jpeg" onchange="upload(this,'img${status.index+1}','img${status.index+1}')" id="typeicon${status.index+1}"/>
						<input type="hidden" name="img${status.index+1}" value="${img.path }"/>
					</div>
				</div>
				</c:forEach>
			</c:if>
			<div class="item">
				<div class="label">首页推荐:</div>
				<div class="input">
					<label><input type="radio" name="isrecomment" value="0" <c:if test="${brand.isrecomment==null || brand.isrecomment=='0' }">checked="checked"</c:if> checked="checked"/>否</label>
					<label><input type="radio" name="isrecomment" <c:if test="${brand.isrecomment=='1' }">checked="checked"</c:if> value="1"/>是</label>
				</div>
			</div>
			<%-- <div class="item">
				<div class="label">状态:</div>
				<div class="input">
					<label><input type="radio" name="status" value="0" <c:if test="${brand.status==null || brand.status=='0' }">checked="checked"</c:if> checked="checked"/>启用</label>
					<label><input type="radio" name="status" <c:if test="${brand.status=='1' }">checked="checked"</c:if> value="1"/>禁用</label>
				</div>
			</div> --%>
			<div class="item full">
				<div class="label">简介:</div>
				<div class="input">
					<textarea rows="5" cols="70" name="intro">${brand.intro }</textarea>
				</div>
			</div>
			<div style="clear:both;"></div>
			<div class="item full">
				<div class="label">详细介绍:</div>
				<div class="input">
					<script id="ueditor" name="detailintro" style="height:300px;"></script>
				</div>
			</div>
			<div style="clear:both;"></div>
		</div>
		<div class="btnDiv">
			<a id="saveBtn" href="javascript:void(0);" onclick="saveBrand()" class="easyui-linkbutton" data-options="iconCls:'icon-save'">保存</a>
		</div>
	</form>
  </body>
</html>
