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
    <title>设计师品牌管理</title>
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
			$('#brandTable').datagrid({
				title:'设计师品牌列表', //标题
				method:'post',
				iconCls:'icon-list', //图标
				singleSelect:false, //多选
				height:370, //高度
				nowrap: true,// True 就会把数据显示在一行里。
				autoRowHeight: false, // 自动调整行高
				fitColumns: true, //自动调整各列，用了这个属性，下面各列的宽度值就只是一个比例。
				striped: true, //奇偶行颜色不同
				collapsible:true,//可折叠
				url:"<%=request.getContextPath()%>/brand/searchBrands.action", //数据来源
				remoteSort : false, //服务器端排序
				idField:'id', //主键字段
				queryParams:{}, //查询条件
				pagination:true, //显示分页
				rownumbers:true, //显示行号
				columns:[[
					{field:'ck',checkbox:true,width:2}, //显示复选框
					{field:'img',title:'图片',width:60,sortable:false,align:'center',
						formatter:function(value,row,index){
							return "<img width='25' onclick='showImg(this)' height='25' src='${ftppath}"+row.img+"'/>";
						} 
					},
					{field:'name',title:'名称',width:60,sortable:false,align:'center',
						formatter:function(value,row,index){return row.name;}
					},
					{field:'type',title:'类型',width:60,sortable:false,align:'center',
						formatter:function(value,row,index){
							if(row.type=="0"){
								return "设计师品牌";
							}
							else{
								return "联名合作";
							}
						} 
					},
					{field:'status',title:'状态',width:60,sortable:false,align:'center',
						formatter:function(value,row,index){return row.status=='0'?'启用':'禁用';}
					},
					{field:'sortno',title:'排序编号',width:60,sortable:false,align:'left'},
					{field:'createtime',title:'创建时间',width:60,sortable:false,align:'center',
						formatter:function(value,row,index){
							return formatdate(row.createtime);
						} 
					}
				]],
				toolbar:[{
					text:'新增',
					iconCls:'icon-add',
					handler:function(){
						addBrand();
					}
				},'-',{
					text:'更新',
					iconCls:'icon-edit',
					handler:function(){
						updateBrand();
					}
				},'-',{
					text:'删除',
					iconCls:'icon-cancel',
					handler:function(){
						deleteBrand();
					}
				},'-',{
					text:'启用',
					iconCls:'icon-ok',
					handler:function(){
						updateStatus(0);
					}
				},'-',{
					text:'禁用',
					iconCls:'icon-no',
					handler:function(){
						updateStatus(1);
					}
				}],
				onLoadSuccess:function(){
					$('#brandTable').datagrid('clearSelections');
				}
			});
			
		});
		
		
			//表格查询
	function searchBrand(){
		var params = $('#brandTable').datagrid('options').queryParams; //先取得 datagrid 的查询参数
		var fields =$('#queryForm').serializeArray(); //自动序列化表单元素为JSON对象
		$.each( fields, function(i, field){
			params[field.name] = field.value; //设置查询参数
		});
		$('#brandTable').datagrid('load'); //设置好查询参数 reload 一下就可以了
	}
		
	//清空查询条件
	function clearForm(){
		$('#queryForm').form('clear');
		searchBrand();
	}
	
	//添加设计师品牌
	function addBrand(){
		/*$('#dialog').dialog({
		    title: '新增设计师品牌',
		    width: 650,
		    height: 400,
		    closed: false,
		    cache: false,
		    href: '<%=request.getContextPath()%>/brand/initBrandEdit.action',
		    modal: true
		});*/
		var url="<%=request.getContextPath()%>/brand/initBrandEdit.action";
		if(window.parent&&parent.openwindow){
			parent.openwindow("品牌编辑",url);
		}
		else{
			location.href=url;
		}
	}
	
	//修改设计师品牌
	function updateBrand(){
		var rows = $('#brandTable').datagrid('getSelections');
		if(rows.length==0){
			$.messager.alert('提示',"请选择你要更新的设计师品牌",'info');
			return;
		}
		if(rows.length > 1){
			$.messager.alert('提示',"只能选择一个设计师品牌进行更新",'info');
			return;
		}
		var row=$('#brandTable').datagrid('getSelected');
		/*$('#dialog').dialog({
		    title: '修改设计师品牌',
		    width: 650,
		    height: 400,
		    closed: false,
		    cache: false,
		    href: '<%=request.getContextPath()%>/brand/initBrandEdit.action?id='+row.id,
		    modal: true
		});*/
		var url='<%=request.getContextPath()%>/brand/initBrandEdit.action?id='+row.id;
		if(window.parent&&parent.openwindow){
			parent.openwindow("品牌编辑",url);
		}
		else{
			location.href=url;
		}
	}
	
	//删除设计师品牌
	function deleteBrand(){
		var rows = $('#brandTable').datagrid('getSelections');
		if(rows.length==0){
			$.messager.alert('提示',"请选择你要删除的设计师品牌",'info');
			return;
		}
  		$.messager.confirm('提示','删除将无法恢复,确定要删除吗?',function(result){
	        if (result){
	        	var rows = $('#brandTable').datagrid('getSelections');
	        	var ps = "";
	        	$.each(rows,function(i,n){
	        		ps+=n.id+",";
	        	});
	        	if(ps.length>0) ps=ps.substring(0,ps.length-1);
	        	$.post('<%=request.getContextPath()%>/brand/deleteBrand.action?ids='+ps,function(data){
		        	$('#brandTable').datagrid('load'); 
    				searchBrand();
    				$.messager.alert('提示',data,'info');
	        	});
	        }
	    });
	}
	
	//更新设计师品牌状态
	function updateStatus(status){
		var tooltip="";
		if(status==0){
			tooltip="启用";
		}
		else{
			tooltip="禁用";
		}
		var rows = $('#brandTable').datagrid('getSelections');
		if(rows.length==0){
			$.messager.alert('提示',"请选择你要"+tooltip+"的设计师品牌",'info');
			return;
		}
  		$.messager.confirm('提示','您确认要批量'+tooltip+'选择项?',function(result){
	        if (result){
	        	var rows = $('#brandTable').datagrid('getSelections');
	        	var ps = "";
	        	$.each(rows,function(i,n){
	        		ps+=n.id+",";
	        	});
	        	if(ps.length>0) ps=ps.substring(0,ps.length-1);
	        	$.post('<%=request.getContextPath()%>/brand/updateBrandStatus.action?status='+status+'&ids='+ps,function(data){
		        	$('#brandTable').datagrid('load'); 
    				searchBrand();
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
  				<td align="right" width="10%">设计师品牌名称:</td>
  				<td align="left" width="20%"><input type="text" name="name" id="name"/></td>
  				<td width="30%" colspan="2">
  					<a id="clearBtn" href="javascript:void(0)" class="easyui-linkbutton" onclick="clearForm()" data-options="iconCls:'icon-clear2'">清空</a>
  					<a id="searchBtn" href="javascript:void(0)" class="easyui-linkbutton" onclick="searchBrand()" data-options="iconCls:'icon-search'">查询</a>
  			    </td>
  			</tr>
  		</table>
  	</form>
  	<div class="tableDiv" style="padding: 5px;">
  		<table id="brandTable"></table>
  	</div>
  	<div id="dialog" style="padding: 5px;">   
	</div> 
  </body>
</html>
