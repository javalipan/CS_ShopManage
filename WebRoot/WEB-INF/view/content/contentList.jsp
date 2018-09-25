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
	<script type="text/javascript" charset="utf-8" src="http://<%=request.getServerName()+":"+request.getServerPort() %>/ueditor/ueditor.config.js"></script>
	<script type="text/javascript" charset="utf-8" src="http://<%=request.getServerName()+":"+request.getServerPort() %>/ueditor/ueditor.all.min.js"> </script>
	<!--建议手动加在语言，避免在ie下有时因为加载语言失败导致编辑器加载失败-->
	<!--这里加载的语言文件会覆盖你在配置项目里添加的语言类型，比如你在配置项目里配置的是英文，这里加载的中文，那最后就是中文-->
	<script type="text/javascript" charset="utf-8" src="http://<%=request.getServerName()+":"+request.getServerPort() %>/ueditor/lang/zh-cn/zh-cn.js"></script>
	<script type="text/javascript">
		$(function(){
			//初始化表格
			$('#contentTable').datagrid({
				title:'内容列表', //标题
				method:'post',
				iconCls:'icon-list', //图标
				singleSelect:false, //多选
				height:370, //高度
				nowrap: true,// True 就会把数据显示在一行里。
				autoRowHeight: false, // 自动调整行高
				fitColumns: true, //自动调整各列，用了这个属性，下面各列的宽度值就只是一个比例。
				striped: true, //奇偶行颜色不同
				collapsible:true,//可折叠
				url:"<%=request.getContextPath()%>/content/searchContentData.action", //数据来源
				remoteSort : false, //服务器端排序
				idField:'id', //主键字段
				queryParams:{programid:'${programid}'}, //查询条件
				pagination:true, //显示分页
				rownumbers:true, //显示行号
				columns:[[
					{field:'ck',checkbox:true,width:2}, //显示复选框
					{field:'title',title:'标题',width:60,sortable:false,align:'center',
						formatter:function(value,row,index){return row.title;}
					},
					{field:'subtitle',title:'副标题',width:60,sortable:false,align:'center'},
					{field:'hits',title:'点击量',width:60,sortable:false,align:'center'},
					{field:'starttime',title:'生效时间起',width:60,sortable:false,align:'center',
						formatter:function(value,row,index){
							return formatdate(row.starttime);
						} 
					},
					{field:'endtime',title:'生效时间止',width:60,sortable:false,align:'center',
						formatter:function(value,row,index){
							return formatdate(row.endtime);
						} 
					},
					{field:'createtime',title:'创建时间',width:60,sortable:false,align:'center',
						formatter:function(value,row,index){
							return formattime(row.createtime);
						} 
					},
					{field:'sortno',title:'排序',width:60,sortable:false,align:'left'}
				]],
				toolbar:[{
					text:'新增',
					iconCls:'icon-add',
					handler:function(){
						addContent();
					}
				},'-',{
					text:'更新',
					iconCls:'icon-edit',
					handler:function(){
						updateContent();
					}
				},'-',{
					text:'删除',
					iconCls:'icon-cancel',
					handler:function(){
						deleteContent();
					}
				}],
				onLoadSuccess:function(){
					$('#contentTable').datagrid('clearSelections');
				}
			});
			
		});
		
		
			//表格查询
	function searchContent(){
		var params = $('#contentTable').datagrid('options').queryParams; //先取得 datagrid 的查询参数
		var fields =$('#queryForm').serializeArray(); //自动序列化表单元素为JSON对象
		$.each( fields, function(i, field){
			params[field.name] = field.value; //设置查询参数
		});
		$('#contentTable').datagrid('load'); //设置好查询参数 reload 一下就可以了
	}
		
	//清空查询条件
	function clearForm(){
		$('#queryForm').form('clear');
		searchContent();
	}
	
	//添加内容
	function addContent(){
		$('#dialog').dialog({
		    title: '新增内容',
		    width: 680,
		    height: 400,
		    closed: false,
		    cache: false,
		    href: '<%=request.getContextPath()%>/content/initContentEdit.action?programid=${programid}',
		    modal: true,
		    onClose:function(){
		    	UE.getEditor('ueditor').destroy();
		    }
		});
	}
	
	//修改内容
	function updateContent(){
		var rows = $('#contentTable').datagrid('getSelections');
		if(rows.length==0){
			$.messager.alert('提示',"请选择你要更新的内容",'info');
			return;
		}
		if(rows.length > 1){
			$.messager.alert('提示',"只能选择一个内容进行更新",'info');
			return;
		}
		var row=$('#contentTable').datagrid('getSelected');
		$('#dialog').dialog({
		    title: '修改内容',
		    width: 680,
		    height: 400,
		    closed: false,
		    cache: false,
		    href: '<%=request.getContextPath()%>/content/initContentEdit.action?programid=${programid}&id='+row.id,
		    modal: true,
		    onClose:function(){
		    	UE.getEditor('ueditor').destroy();
		    }
		});
	}
	
	//删除内容
	function deleteContent(){
		var rows = $('#contentTable').datagrid('getSelections');
		if(rows.length==0){
			$.messager.alert('提示',"请选择你要删除的内容",'info');
			return;
		}
  		$.messager.confirm('提示','删除将无法恢复,确定要删除吗?',function(result){
	        if (result){
	        	var rows = $('#contentTable').datagrid('getSelections');
	        	var ps = "";
	        	$.each(rows,function(i,n){
	        		ps+=n.id+",";
	        	});
	        	if(ps.length>0) ps=ps.substring(0,ps.length-1);
	        	$.post('<%=request.getContextPath()%>/content/deleteContent.action?ids='+ps,function(data){
		        	$('#contentTable').datagrid('load'); 
    				searchContent();
    				$.messager.alert('提示',data,'info');
	        	});
	        }
	    });
	}
	
	</script>
  </head>
  
  <body>
    <form action="" method="post" id="queryForm">
  		<table border="0">
  			<tr>
  				<td align="right" width="10%">标题:</td>
  				<td align="left" width="20%"><input type="text" name="title" id="title"/></td>
  				<td width="30%" colspan="2">
  					<a id="clearBtn" href="javascript:void(0)" class="easyui-linkbutton" onclick="clearForm()" data-options="iconCls:'icon-clear2'">清空</a>
  					<a id="searchBtn" href="javascript:void(0)" class="easyui-linkbutton" onclick="searchContent()" data-options="iconCls:'icon-search'">查询</a>
  			    </td>
  			</tr>
  		</table>
  	</form>
  	<div class="tableDiv" style="padding: 5px;">
  		<table id="contentTable"></table>
  	</div>
  	<div id="dialog" style="padding: 5px;">   
	</div> 
  </body>
</html>
