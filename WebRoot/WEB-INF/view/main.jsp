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
    <title>后台管理系统</title>
	<meta http-equiv="pragma" content="no-cache">
	<meta http-equiv="cache-control" content="no-cache">
	<meta http-equiv="expires" content="0">    
	<meta http-equiv="keywords" content="keyword1,keyword2,keyword3">
	<meta http-equiv="description" content="This is my page">
	<meta http-equiv="X-UA-Compatible" content="IE=EmulateIE8"/>
	<link rel="icon" href="${ctx }/favicon.ico" type="image/x-icon"/>
	
	<jsp:include page="/tags.jsp"></jsp:include>
	<style type="text/css">
		.menuitem a{color:#000;text-decoration: none;display: block;padding: 5px;}
		.menuitem a:hover{color:#000;text-decoration: none;background: #E6E6E6;}
	</style>
	<script type="text/javascript">
		$(function(){
			$("#aa a").click(function(){
				var title=$(this).find("span").text();
				if(title==null||title==""){
					return;
				}
				openwindow(title,$(this).attr("src"));
			});
			
		});
		//修改密码
		function modifyPass(){
			$('#passworddialog').dialog({
			    title: '修改密码',
			    width: 350,
			    height: 250,
			    closed: false,
			    cache: false,
			    href: '<%=request.getContextPath()%>/user/initModifyPassword.action',
			    modal: true
			});
		}
		
		function openwindow(title,url){
			var tt = $('#tabs');
			if (tt.tabs('exists', title)){//如果tab已经存在,则选中并刷新该tab
				tt.tabs('select', title);
				var tab = tt.tabs('getSelected').find("iframe");
				tab.attr("src",url);
			}
			else{
				tt.css("height",(parseInt($(window).height())-50)+"px");
				var content = '<iframe frameborder="0"  src="'+url+'" width="100%" height="'+(parseInt($(window).height())-150)+'"></iframe>';
				tt.tabs('add',{
		            title:title,
		            closable:true,
		            content:content,
		            iconCls:$(this).attr("icon")
		        });
			}
		}
		
		function closeTabAndOpen(closetitle,title,url){
			var tt = $('#tabs');
			if (tt.tabs('exists', title)){//如果tab已经存在,则选中并刷新该tab
				tt.tabs('select', title);
				var tab = tt.tabs('getSelected').find("iframe");
				tab.attr("src",tab.attr("src"));
			}
			else{
				tt.css("height",(parseInt($(window).height())-50)+"px");
				var content = '<iframe frameborder="0"  src="'+url+'" width="100%" height="'+(parseInt($(window).height())-150)+'"></iframe>';
				tt.tabs('add',{
		            title:title,
		            closable:true,
		            content:content,
		            iconCls:$(this).attr("icon")
		        });
			}
			tt.tabs('close',closetitle);
		}
	</script>
  </head>
  
  <body class="easyui-layout">
   	<div data-options="region:'north'" style="height:47px;background:url(images/headbg.png)">
   		<div style="float:left;color:#fff;font-weight: bold;font-size:24px;margin:10px 0 0 100px;">尺尚管理平台</div>
   		<div style="float:right;color:rgb(253,255,60);margin:15px 100px 0 0;">用户:${USER_INFO.name},您好，欢迎使用系统 　　<a style="color:#fff;text-decoration: none;" href="javascript:modifyPass()">修改密码</a>　 <a style="color:#fff;text-decoration: none;" href="javascript:void(0)" onclick="if(window.confirm('您确认要注销吗?'))location.href='${ctx}/manage/logout.do'">注销</a></div>
   	</div>
    <div data-options="region:'west',title:'管理菜单',split:true" style="width:300px;">
    	<div id="aa" class="easyui-accordion" style="width:290px;">
    		<c:forEach items="${menus}" var="menu">
    			<c:if test="${menu.pid=='0'}">
	    			<div class="menuitem" title="${menu.name}" data-options="selected:true,iconCls:'icon-user'" style="padding:10px;height: 300px;">
	    				<c:forEach items="${menus}" var="children">
	    					<c:if test="${children.pid==menu.id}">
							<a href="javascript:void(0)" icon="icon-user" src="<%=basePath %>${children.url}"><span>${children.name}</span></a>
							</c:if>
						</c:forEach>
				    </div>   
    			</c:if>
    		</c:forEach>
    	</div>
    </div>   
    <div data-options="region:'center'" style="padding:5px;background:#fff;">
    	<div id="tabs" class="easyui-tabs" style="background:#fff">
		</div> 
    </div>   
   	<div data-options="region:'south'" style="height:47px;background:url(images/headbg.png)">
   		<div style="height:40px;color:red;text-align: center;line-height:40px;font-size:18px;">尺尚管理平台</div>
   	</div>
   	
   	<div id="passworddialog" style="padding: 5px;">   
	</div> 
  </body>
</html>
