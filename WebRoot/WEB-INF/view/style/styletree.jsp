<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
	<title>风格管理</title>
	<meta http-equiv="X-UA-Compatible" content="IE=EmulateIE9"/>
	<meta http-equiv="Content-Type" content="text/html; charset=UTF-8"/>
	<meta http-equiv="pragma" content="no-cache"/>
	<meta http-equiv="cache-control" content="no-cache"/>
	<script language="javascript" type="text/javascript" src="${ctx }/js/jquery.min.js"></script>
	
	<link rel="stylesheet" type="text/css" href="${ctx }/js/easyui/themes/bootstrap/easyui.css"/>
	<link rel="stylesheet" type="text/css" href="${ctx }/js/easyui/themes/icon.css"/>
	<script type="text/javascript" src="${ctx }/js/easyui/jquery.easyui.min.js"></script>
	<script type="text/javascript" src="${ctx }/js/easyui/locale/easyui-lang-zh_CN.js"></script>
</head>
  
  <body>
  		<div style="height:30px;position: fixed;top:0;">
  			<a id="addType" onclick="addType()" href="#" class="easyui-linkbutton" data-options="iconCls:'icon-add'">添加根类</a>
  			<a id="add" href="#" class="easyui-linkbutton" data-options="iconCls:'icon-add'">添加子类</a>  
  			<a id="deleteCode" href="#" class="easyui-linkbutton" data-options="iconCls:'icon-remove'">删除</a>  
  		</div>
  		<div style="margin-top:30px;"><ul id="dictTree"></ul></div>
  		
  		<div id="addDialog" style="display: none">
  			<form id="form1">
			    <div class="row"><div class="rowtitle">名称:</div><input class="inputtxt" name="name" type="text" /></div>
  			</form>
		</div>
		
  		<div id="addDialog2" style="display: none">   
		    <form id="form2">
		    	<input class="inputtxt" name="parentid" id="parentid" type="hidden" />
			    <div class="row"><div class="rowtitle">名称:</div><input class="inputtxt" name="name" type="text" /></div>
		    </form>
		</div>
	<style>
		.row{width:280px;height:30px;float: left;padding-top: 5px;}
		.rowtitle{width:70px;float: left;text-align: right;line-height: 25px;}
		.inputtxt{width:150px;}
	</style>
  		<script>
  		$(function(){
  			
  			//初始化树
  			$('#dictTree').tree({
  	  			method : 'post',
  	  			animate:true,
  	  			lines:true,
  	  			url : '<%=request.getContextPath()%>/style/getTreeData.do',
  	  			onBeforeExpand:function(node){	//展开之前的事件
  	  				if(node.attributes.code){
  		  				$("#dictTree").tree("options").url="<%=request.getContextPath()%>/style/getTreeData.do?type="+node.id;
  	  				}
  	  				else{
  	  					$("#dictTree").tree("options").url="<%=request.getContextPath()%>/style/getTreeData.do";
  	  				}
  	  			}
  	  		});
  			
  			//添加子节点
  			$("#add").click(function(){
  				var node=$("#dictTree").tree("getSelected");
  				if(!node){
  					$.messager.alert('提示信息','请选择父节点'); 
  					return;
  				}
  				$("#parentid").val(node.id);
  				$("#addDialog2").show();
  				$("#form2 input[type='text']").val("");
  				$('#addDialog2').dialog({
  				    title: '添加',    
  				    width: 300,    
  				    height: 130,    
  				    closed: false,
  				    cache: false,    
  				    modal: true ,
	  				buttons:[{
	  					text:'保存',
	  					handler:function(){
	  						save("#form2");
	  					}
	  				}]
  				}); 
  			});
  			
  		//删除
  			$("#deleteCode").click(function(){
  				var node=$("#dictTree").tree("getSelected");
  				if(!node){
  					$.messager.alert('提示信息','请选择要删除的节点'); 
  					return;
  				}
  				$.messager.confirm('提示','请确保删除数据未被使用!!!删除将无法恢复,确定要删除吗?',function(result){
  			        if (result){
  			        	$.ajax({
  			  				url:'${ctx}/style/deleteStyle.action',
  			  				type:'POST',
  			  				data:{
  			  					id:node.id
  			  				},
  			  				dataType:"json",
  			  				success:function(data){
  			  					if(data.result){
		  			  				var node=$("#dictTree").tree("getSelected");
		  		  					$("#dictTree").tree("remove",node.target);
  			  					}
  			  					else{
  			  					$.messager.alert('提示信息',data.mes); 
  			  					}
  			  				}
  			  			});
  			        }
  				});
  			});
  		});
  		
  		function save(id){
  			$.ajax({
  				url:'${ctx}/style/addStyle.do',
  				type:'POST',
  				data:$(id).serialize(),
  				success:function(data){
  					var dialogid=$(id).parent().attr("id");
  					$("#"+dialogid).dialog("close");
  					if(id=="#form1"){
  						window.location.reload();
  					}
  					else{
	  					var node=$("#dictTree").tree("getSelected");
	  					$("#dictTree").tree("reload",node.target);
  					}
  				}
  			});
  		}
  		
  		//添加类型（第一级）
		function addType(){
			$("#addDialog").show();
			$("#form1 input[type='text']").val("");
			$('#addDialog').dialog({
			    title: '添加',    
			    width: 300,    
			    height: 130,    
			    closed: false,
			    cache: false,    
			    modal: true ,
 				buttons:[{
 					text:'保存',
 					handler:function(){
 						save("#form1");
 					}
 				}]
			}); 
		}
  		</script>
  </body>
</html>
