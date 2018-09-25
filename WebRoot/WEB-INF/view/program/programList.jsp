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
    <title>栏目管理</title>
	<meta http-equiv="pragma" content="no-cache">
	<meta http-equiv="cache-control" content="no-cache">
	<meta http-equiv="expires" content="0">    
	<meta http-equiv="keywords" content="keyword1,keyword2,keyword3">
	<meta http-equiv="description" content="This is my page">
	<meta http-equiv="X-UA-Compatible" content="IE=EmulateIE8"/>
	<jsp:include page="/tags.jsp"></jsp:include>
	<script type="text/javascript">
		$(function(){
			//初始化表格
			$('#programTable').treegrid({
				title : '栏目列表', //标题
				method : 'post',
				scrollbarSize :1,
				url : '${ctx}/program/searchProgramData.action',
				iconCls : 'icon-list', //图标
				singleSelect : true, //多选
				fitColumns : true, //自动调整各列，用了这个属性，下面各列的宽度值就只是一个比例。
				striped : false, //奇偶行颜色不同
				idField: 'id',
				treeField : 'text', //主键字段
				pagination : false, //显示分页
				rownumbers : false, //显示行号
				columns : [ [{
					field : 'text',
					title : '名称',
					width : 80,
					align:'left',
				},{
					field : 'id',
					title : '操作',
					width : 18,
					align:'center',
					formatter: function(value,row,index){
						var html="";
						if(row.attributes.parentid=='0'){
							html+="<a class='trbutton' href='javascript:addProgram("+row.id+")'>添加</a>&nbsp;&nbsp;";
						}
						html+="<a class='trbutton' href='javascript:updateProgram("+row.id+")'>修改</a>&nbsp;&nbsp;";
						if(row.attributes.issystem=='0'&&$('#programTable').treegrid("getChildren",row.id).length<=0){
							html+="<a class='trbutton' href='javascript:deleteProgram("+row.id+")'>删除</a>&nbsp;&nbsp;";
						}
						return html;
					}
				} ] ],
				toolbar:[{
					text:'新增',
					iconCls:'icon-add',
					handler:function(){
						addProgram();
					}
				}]
			}); 
			
		});
		
		//添加栏目
		function addProgram(pid){
			var url="${ctx}/program/initProgramEdit.action";
			if(pid){
				url="${ctx}/program/initProgramEdit.action?parentid="+pid;
			}
			$('#dialog').dialog({
			    title: '新增栏目',
			    width: 650,
			    height: 300,
			    closed: false,
			    cache: false,
			    href: url,
			    modal: true
			});
		}
		
		//修改栏目
		function updateProgram(id){
			url="${ctx}/program/initProgramEdit.action?id="+id;
			$('#dialog').dialog({
			    title: '新增栏目',
			    width: 650,
			    height: 300,
			    closed: false,
			    cache: false,
			    href: url,
			    modal: true
			});
		}
		
		function deleteProgram(id){
			$.messager.confirm('提示','删除将无法恢复,确定要删除吗?',function(result){
		        if (result){
		        	$.post('${ctx}/program/deleteProgram.action?id='+id,function(data){
			        	$('#programTable').treegrid('load'); 
	    				$.messager.alert('提示',data,'info');
		        	});
		        }
		    });
		}
	</script>
  </head>
  
  <body>
  	<div class="tableDiv" style="padding: 5px;">
  		<table id="programTable"></table>
  	</div>
  	<div id="dialog" style="padding: 5px;">   
	</div> 
  </body>
</html>
