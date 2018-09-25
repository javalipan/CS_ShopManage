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
    <title>缓存管理</title>
	<meta http-equiv="pragma" content="no-cache">
	<meta http-equiv="cache-control" content="no-cache">
	<meta http-equiv="expires" content="0">    
	<meta http-equiv="keywords" content="keyword1,keyword2,keyword3">
	<meta http-equiv="description" content="This is my page">
	<meta http-equiv="X-UA-Compatible" content="IE=EmulateIE8"/>
	<jsp:include page="/tags.jsp"></jsp:include>
	<script type="text/javascript">
	function initData(url){
		$.ajax({
			url:"${ctx}/data/initData.action",
			data:{
				url:url
			},
			success:function(data){
				$.messager.alert('提示',data,'info');
			}
		});
	}
	</script>
  </head>
  
  <body>
  	<a id="clearBtn" href="javascript:void(0)" class="easyui-linkbutton" onclick="initData('/clearAllCache')" data-options="iconCls:'icon-clear2'">清空微信缓存</a>
  	<a id="clearBtn" href="javascript:void(0)" class="easyui-linkbutton" onclick="initData('/data/initMemberType')" data-options="iconCls:'icon-reload'">初始化会员类型</a>
  	<a id="clearBtn" href="javascript:void(0)" class="easyui-linkbutton" onclick="initData('/data/initLabelData')" data-options="iconCls:'icon-reload'">初始化会员标签</a>
  </body>
</html>
