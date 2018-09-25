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
    <title>内容管理</title>
	<meta http-equiv="pragma" content="no-cache">
	<meta http-equiv="cache-control" content="no-cache">
	<meta http-equiv="expires" content="0">    
	<meta http-equiv="keywords" content="keyword1,keyword2,keyword3">
	<meta http-equiv="description" content="This is my page">
	<meta http-equiv="X-UA-Compatible" content="IE=EmulateIE8"/>
	<jsp:include page="/tags.jsp"></jsp:include>
	<script type="text/javascript">
		$(function(){
			$("#aa").css("height",(parseInt($(window).height())-50)+"px");
			$("iframe").css("height",(parseInt($(window).height())-50)+"px");
			
			$('#programTree').tree({    
			    url: '${ctx}/program/searchProgramData.action',
			    onClick:function(node){
			    	if($("#programTree").tree("isLeaf",node.target)){
			    		$("iframe").css("height",(parseInt($(window).height())-50)+"px");
			    		$("iframe").attr("src",'${ctx}/content/initContentList.action?programid='+node.id);
			    	}
			    }
			}); 
		});
	</script>
  </head>
  
  <body class="easyui-layout">
    <div data-options="region:'west',title:'栏目',split:true" style="width:200px;">
    	<div id="aa" class="easyui-accordion" style="width:190px;">
    		<ul id="programTree"></ul>
    	</div>
    </div>   
    <div data-options="region:'center'" style="padding:5px;background:#fff;">
    	<div id="tabs" class="easyui-tabs" style="background:#fff">
    		<div title="内容列表">   
    			<iframe frameborder="0"  width="100%"></iframe>
		    </div>   
		</div> 
    </div>   
  </body>
</html>
