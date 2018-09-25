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
    <title>角色权限</title>
	<meta http-equiv="pragma" content="no-cache">
	<meta http-equiv="cache-control" content="no-cache">
	<meta http-equiv="expires" content="0">    
	<meta http-equiv="keywords" content="keyword1,keyword2,keyword3">
	<meta http-equiv="description" content="This is my page">
	<meta http-equiv="X-UA-Compatible" content="IE=EmulateIE8"/>
  </head>
  
  <body>
	<script type="text/javascript">
		$(function(){
			var height=$(window).height()-50;
			$("#tree").parent().css({
				height:height
			});
			 $('#tree').tree({
                 checkbox: true,
                 url: '<%=request.getContextPath()%>/role/getMenuTree.action?roleid=${roleid}',
                 lines:true,
                 cascadeCheck:false,
                 onClick:function(node){
                	 $('#tree').tree('toggle',node.target);
                 },
                 onCheck:function(node, checked){
                	 if (checked) {
                        var parentNode = $("#tree").tree('getParent', node.target);
                        if (parentNode != null) {
                            $("#tree").tree('check', parentNode.target);
                        }
                    } else {
                        var childNode = $("#tree").tree('getChildren', node.target);
                        if (childNode.length > 0) {
                            for (var i = 0; i < childNode.length; i++) {
                                $("#tree").tree('uncheck', childNode[i].target);
                            }
                        }
                	 }
               	 }
                 
              }); 
		});
		
		function savePermission(){
			var checked= $('#tree').tree("getChecked");
			var ids="";
			for(var i in checked){
				ids+=checked[i].id+",";
			}
			if(ids.length>1){
				ids=ids.substring(0,ids.length-1);
			}
			$.ajax({
      				url:'<%=request.getContextPath()%>/role/setRolePermission.action?roleid=${roleid}&menuids='+ids,
                     asysc:false,
                     type:'POST',
                     success:function(data){
	 				$.messager.alert('提示',data,'info');
	       		}
      		});
		}
	</script>
  	<div style="overflow:auto;"><ul id="tree"></ul></div>  
  	<div style="width:100%;position: absolute;bottom: 10px;text-align: center;">
  		<a id="saveBtn" href="javascript:void(0)" class="easyui-linkbutton" onclick="savePermission()" data-options="iconCls:'icon-save'">保存</a>
  	</div>
  </body>
</html>
