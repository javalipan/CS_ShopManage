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
    <title>商品管理</title>
	<meta http-equiv="pragma" content="no-cache">
	<meta http-equiv="cache-control" content="no-cache">
	<meta http-equiv="expires" content="0">    
	<meta http-equiv="keywords" content="keyword1,keyword2,keyword3">
	<meta http-equiv="description" content="This is my page">
	<meta http-equiv="X-UA-Compatible" content="IE=EmulateIE8"/>
	<jsp:include page="/tags.jsp"></jsp:include>
	<script type="text/javascript">
		$(function(){
			$("#typeid").combotree({
				url:'${ctx}/type/searchTypeData.action',
				onSelect : function(node) {  
			        //返回树对象  
			        var tree = $(this).tree;  
			        //选中的节点是否为叶子节点,如果不是叶子节点,清除选中  
			        var isLeaf = tree('isLeaf', node.target);  
			        if (!isLeaf) {  
			            //清除选中  
			            $('#typeid').combotree('clear');  
			        }  
			        else{
			        	searchGoods();
			        }
			    }
			});
			
			//初始化表格
			$('#goodsTable').datagrid({
				title:'商品列表', //标题
				method:'post',
				iconCls:'icon-list', //图标
				singleSelect:false, //多选
				height:370, //高度
				nowrap: true,// True 就会把数据显示在一行里。
				autoRowHeight: false, // 自动调整行高
				fitColumns: true, //自动调整各列，用了这个属性，下面各列的宽度值就只是一个比例。
				striped: true, //奇偶行颜色不同
				collapsible:true,//可折叠
				url:"<%=request.getContextPath()%>/goods/searchGoodss.action", //数据来源
				remoteSort : false, //服务器端排序
				idField:'id', //主键字段
				queryParams:{}, //查询条件
				pagination:true, //显示分页
				rownumbers:true, //显示行号
				columns:[[
					{field:'ck',checkbox:true,width:2}, //显示复选框
					{field:'type',title:'图片',width:60,sortable:false,align:'center',
						formatter:function(value,row,index){
							return "<img width='25' height='25' onclick='showImg(this)' src='${ftppath}"+row.img+"'/>";
						} 
					},
					{field:'code',title:'编码',width:60,sortable:false,align:'center',
						formatter:function(value,row,index){
							return "<a class='trbutton' onclick='showDetail("+row.id+")' href='javascript:void(0)'>"+row.code+"</a>";
						} 
					},
					{field:'brandname',title:'品牌名称',width:60,sortable:false,align:'center',
						formatter:function(value,row,index){return row.brandname;}
					},
					{field:'name',title:'名称',width:60,sortable:false,align:'center',
						formatter:function(value,row,index){return row.name;}
					},
					{field:'amount',title:'库存总量',width:60,sortable:false,align:'left'},
					{field:'createtime',title:'创建时间',width:60,sortable:false,align:'center',
						formatter:function(value,row,index){
							return formatdate(row.createtime);
						} 
					},
					{field:'updatetime',title:'更新时间',width:60,sortable:false,align:'center',
						formatter:function(value,row,index){
							return formatdate(row.updatetime);
						} 
					},
					{field:'status',title:'状态',width:60,sortable:false,align:'center',
						formatter:function(value,row,index){
							return row.status=='0'?'<span class="red">未上架</span>':(row.status=='1'?'<span class="green">上架</span>':'<span class="red">下架</span>');
						}
					},
					{field:'isrecomment',title:'首页推荐',width:60,sortable:false,align:'center',
						formatter:function(value,row,index){
							return row.isrecomment=='0'?'<span class="red">否</span>':'<span class="green">推荐</span>';
						}
					},
					{field:'isnew',title:'新品',width:60,sortable:false,align:'center',
						formatter:function(value,row,index){
							return row.isnew=='0'?'<span class="red">否</span>':'<span class="green">新品</span>';
						}
					},
					{field:'sortno',title:'排序',width:30,sortable:false,align:'center',
						formatter:function(value,row,index){
							return "<input type='text' onchange='modifysort("+row.id+",this)' value='"+row.sortno+"'/>";
						}
					},
					{field:'options',title:'操作',width:60,sortable:false,align:'center',
						formatter:function(value,row,index){
							return "<a class='trbutton' href='javascript:void(0)' onclick='showDetail("+row.id+")'>详情</a>";
						}
					}
				]],
				toolbar:[{
					text:'新增',
					iconCls:'icon-add',
					handler:function(){
						addGoods();
					}
				},'-',{
					text:'更新',
					iconCls:'icon-edit',
					handler:function(){
						updateGoods();
					}
				},'-',{
					text:'删除',
					iconCls:'icon-cancel',
					handler:function(){
						deleteGoods();
					}
				},'-',{
					text:'上架',
					iconCls:'icon-up',
					handler:function(){
						updateStatus(1);
					}
				},'-',{
					text:'下架',
					iconCls:'icon-down',
					handler:function(){
						updateStatus(2);
					}
				},'-',{
					text:'推荐',
					iconCls:'icon-edit',
					handler:function(){
						updateRecomment(1);
					}
				},'-',{
					text:'取消推荐',
					iconCls:'icon-edit',
					handler:function(){
						updateRecomment(0);
					}
				},'-',{
					text:'新品',
					iconCls:'icon-edit',
					handler:function(){
						updateNew(1);
					}
				},'-',{
					text:'取消新品',
					iconCls:'icon-edit',
					handler:function(){
						updateNew(0);
					}
				},'-',{
					text:'设置折扣',
					iconCls:'icon-edit',
					handler:function(){
						setDiscount();
					}
				},'-',{
					text:'取消折扣',
					iconCls:'icon-edit',
					handler:function(){
						calcelDiscount();
					}
				},'-',{
					text:'导出',
					iconCls:'icon-excel',
					handler:function(){
						exportExcel();
					}
				}],
				onLoadSuccess:function(){
					$('#goodsTable').datagrid('clearSelections');
				}
			});
			
		});
		
		
			//表格查询
	function searchGoods(){
		var params = $('#goodsTable').datagrid('options').queryParams; //先取得 datagrid 的查询参数
		var fields =$('#queryForm').serializeArray(); //自动序列化表单元素为JSON对象
		$.each( fields, function(i, field){
			params[field.name] = field.value; //设置查询参数
		});
		$('#goodsTable').datagrid('load'); //设置好查询参数 reload 一下就可以了
	}
		
	//清空查询条件
	function clearForm(){
		$('#queryForm').form('clear');
		searchGoods();
	}
	
	//添加商品
	function addGoods(){
		if(window.parent&&parent.openwindow){
			parent.openwindow("商品新增","<%=request.getContextPath()%>/goods/initGoodsEdit.action?showcost=${showcost}");
		}
		else{
			location.href='<%=request.getContextPath()%>/goods/initGoodsEdit.action?showcost=${showcost}';
		}
	}
	
	//详情
	function showDetail(id){
		if(window.parent&&parent.openwindow){
			parent.openwindow("商品详情","${ctx}/goods/initGoodsDetail.action?showcost=${showcost}&id="+id);
		}
		else{
			location.href='${ctx}/goods/initGoodsDetail.action?showcost=${showcost}&id='+id;
		}
	}
	
	//修改商品
	function updateGoods(){
		var rows = $('#goodsTable').datagrid('getSelections');
		if(rows.length==0){
			$.messager.alert('提示',"请选择你要更新的商品",'info');
			return;
		}
		if(rows.length > 1){
			$.messager.alert('提示',"只能选择一个商品进行更新",'info');
			return;
		}
		var row=$('#goodsTable').datagrid('getSelected');
		var url='<%=request.getContextPath()%>/goods/initGoodsEdit.action?showcost=${showcost}&id='+row.id;
		if(window.parent&&parent.openwindow){
			parent.openwindow("商品编辑",url);
		}
		else{
			location.href=url;
		}
	}
	
	//删除商品
	function deleteGoods(){
		var rows = $('#goodsTable').datagrid('getSelections');
		if(rows.length==0){
			$.messager.alert('提示',"请选择你要删除的商品",'info');
			return;
		}
  		$.messager.confirm('提示','删除将无法恢复,确定要删除吗?',function(result){
	        if (result){
	        	var rows = $('#goodsTable').datagrid('getSelections');
	        	var ps = "";
	        	var flag=false;
	        	$.each(rows,function(i,n){
	        		if(n.status=="1"){
	        			flag=true;
	        		}
	        		ps+=n.id+",";
	        	});
	        	if(flag){
	        		$.messager.alert('提示',"已上架商品不能删除",'info');
	        		return;
	        	}
	        	if(ps.length>0) ps=ps.substring(0,ps.length-1);
	        	$.post('<%=request.getContextPath()%>/goods/deleteGoods.action?ids='+ps,function(data){
		        	$('#goodsTable').datagrid('load'); 
    				searchGoods();
    				$.messager.alert('提示',data,'info');
	        	});
	        }
	    });
	}
	
	//更新商品状态
	function updateStatus(status){
		var tooltip="";
		if(status==1){
			tooltip="上架";
		}
		else{
			tooltip="下架";
		}
		var rows = $('#goodsTable').datagrid('getSelections');
		if(rows.length==0){
			$.messager.alert('提示',"请选择你要"+tooltip+"的商品",'info');
			return;
		}
  		$.messager.confirm('提示','您确认要批量'+tooltip+'选择项?',function(result){
	        if (result){
	        	var rows = $('#goodsTable').datagrid('getSelections');
	        	var ps = "";
	        	$.each(rows,function(i,n){
	        		ps+=n.id+",";
	        	});
	        	if(ps.length>0) ps=ps.substring(0,ps.length-1);
	        	$.post('<%=request.getContextPath()%>/goods/updateGoodsStatus.action?status='+status+'&ids='+ps,function(data){
		        	$('#goodsTable').datagrid('load'); 
    				searchGoods();
    				$.messager.alert('提示',data,'info');
	        	});
	        }
	    });
	}
	
	//导出excel
	function exportExcel(){
		var querydata=$("#queryForm").serializeArray();
		$("#queryForm").submit();
	}
	
	//更新排序
	function modifysort(id,t){
		var sortno=$(t).val();
		$.post('<%=request.getContextPath()%>/goods/modifysort.action?id='+id+'&sortno='+sortno,function(data){
    	});
	}
	
	
	//更新是否推荐
	function updateRecomment(status){
		var tooltip="";
		if(status==1){
			tooltip="推荐";
		}
		else{
			tooltip="取消推荐";
		}
		var rows = $('#goodsTable').datagrid('getSelections');
		if(rows.length==0){
			$.messager.alert('提示',"请选择你要"+tooltip+"的商品",'info');
			return;
		}
  		$.messager.confirm('提示','您确认要批量'+tooltip+'选择项?',function(result){
	        if (result){
	        	var rows = $('#goodsTable').datagrid('getSelections');
	        	var ps = "";
	        	$.each(rows,function(i,n){
	        		ps+=n.id+",";
	        	});
	        	if(ps.length>0) ps=ps.substring(0,ps.length-1);
	        	$.post('<%=request.getContextPath()%>/goods/updateRecomment.action?isrecomment='+status+'&ids='+ps,function(data){
		        	$('#goodsTable').datagrid('load'); 
    				searchGoods();
    				$.messager.alert('提示',data,'info');
	        	});
	        }
	    });
	}
	
	//更新是否新品
	function updateNew(status){
		var tooltip="";
		if(status==1){
			tooltip="新品";
		}
		else{
			tooltip="取消新品";
		}
		var rows = $('#goodsTable').datagrid('getSelections');
		if(rows.length==0){
			$.messager.alert('提示',"请选择你要"+tooltip+"的商品",'info');
			return;
		}
  		$.messager.confirm('提示','您确认要批量'+tooltip+'选择项?',function(result){
	        if (result){
	        	var rows = $('#goodsTable').datagrid('getSelections');
	        	var ps = "";
	        	$.each(rows,function(i,n){
	        		ps+=n.id+",";
	        	});
	        	if(ps.length>0) ps=ps.substring(0,ps.length-1);
	        	$.post('<%=request.getContextPath()%>/goods/updateNew.action?isnew='+status+'&ids='+ps,function(data){
		        	$('#goodsTable').datagrid('load'); 
    				searchGoods();
    				$.messager.alert('提示',data,'info');
	        	});
	        }
	    });
	}
	
	function setDiscount(){
		var rows = $('#goodsTable').datagrid('getSelections');
		if(rows.length==0){
			$.messager.alert('提示',"请选择你要设置的商品",'info');
			return;
		}
		var ps = "";
    	$.each(rows,function(i,n){
    		ps+=n.id+",";
    	});
    	if(ps.length>0) ps=ps.substring(0,ps.length-1);
    	$('#dialog').dialog({
		    title: '设置折扣',
		    width: 650,
		    height: 300,
		    closed: false,
		    cache: false,
		    href: '<%=request.getContextPath()%>/discount/initSetDiscount.action?ids='+ps,
		    modal: true
		});
	}
	
	function calcelDiscount(){
		var rows = $('#goodsTable').datagrid('getSelections');
		if(rows.length==0){
			$.messager.alert('提示',"请选择你要设置的商品",'info');
			return;
		}
		var ps = "";
    	$.each(rows,function(i,n){
    		ps+=n.id+",";
    	});
    	if(ps.length>0) ps=ps.substring(0,ps.length-1);
    	$.messager.confirm('提示','确认要取消折扣?',function(result){
	        if (result){
	        	$.ajax({
	        		url:"${ctx}/discount/calcelDiscount.action",
	        		data:{
	        			ids:ps
	        		},
	        		type:'POST',
	        		success:function(data){
	        			searchGoods();
	        			$.messager.alert('提示',data,'info');
	        		}
	        	});
	        }
    	});
	}
	
	</script>
  </head>
  
  <body>
    <form action="${ctx}/goods/exportExcel.action" target="_blank" method="post" id="queryForm">
  		<table border="0">
  			<tr>
  				<td align="right" width="8%">商品编码:</td>
  				<td align="left" width="17%"><input type="text" name="codelike" id="codelike"/></td>
  				<td align="right" width="8%">商品名称:</td>
  				<td align="left" width="17%"><input type="text" name="name" id="name"/></td>
  				<td align="right" width="8%">商品分类:</td>
  				<td align="left" width="17%"><input type="text" name="typeid" id="typeid"/></td>
  				<td align="right" width="8%">商品品牌:</td>
  				<td align="left" width="17%">
  					<select name="brandid" class="easyui-combobox" data-options="editable:false,width:147,onChange:function(){searchGoods()}">
						<option value="">商品品牌</option>
						<c:forEach items="${brands }" var="brand">
							<option value="${brand.id }">${brand.name }</option>
						</c:forEach>
					</select>
  				</td>
			</tr>
 			<tr>
  				<td align="right" width="8%">状态:</td>
  				<td align="left" width="17%">
  					<select name="status" class="easyui-combobox" data-options="editable:false,width:147,onChange:function(){searchGoods()}">
						<option value="">商品状态</option>
						<option value="0">未上架</option>
						<option value="1">已上架</option>
						<option value="2">已下架</option>
					</select>
  				</td>
  				<td align="right" width="8%">首页推荐:</td>
  				<td align="left" width="17%">
  					<select name="isrecomment" class="easyui-combobox" data-options="editable:false,width:147,onChange:function(){searchGoods()}">
						<option value="">首页推荐</option>
						<option value="0">否</option>
						<option value="1">是</option>
					</select>
  				</td>
  				<td align="right" width="8%">是否新品:</td>
  				<td align="left" width="17%">
  					<select name="isnew" class="easyui-combobox" data-options="editable:false,width:147,onChange:function(){searchGoods()}">
						<option value="">是否新品</option>
						<option value="0">否</option>
						<option value="1">是</option>
					</select>
  				</td>
  				<td colspan="2" >
  					<a id="clearBtn" href="javascript:void(0)" class="easyui-linkbutton" onclick="clearForm()" data-options="iconCls:'icon-clear2'">清空</a>
  					<a id="searchBtn" href="javascript:void(0)" class="easyui-linkbutton" onclick="searchGoods()" data-options="iconCls:'icon-search'">查询</a>
  			    </td>
  			</tr>
  		</table>
  	</form>
  	<div class="tableDiv" style="padding: 5px;">
  		<table id="goodsTable"></table>
  	</div>
  	<div id="dialog" style="padding: 5px;">   
	</div> 
  </body>
</html>
