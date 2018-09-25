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
    <title>会员管理</title>
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
			$('#dataTable').datagrid({
				title:'会员列表', //标题
				method:'post',
				iconCls:'icon-list', //图标
				singleSelect:false, //多选
				height:370, //高度
				nowrap: true,// True 就会把数据显示在一行里。
				autoRowHeight: false, // 自动调整行高
				fitColumns: true, //自动调整各列，用了这个属性，下面各列的宽度值就只是一个比例。
				striped: true, //奇偶行颜色不同
				collapsible:true,//可折叠
				url:"<%=request.getContextPath()%>/member/searchMember.action", //数据来源
				remoteSort : false, //服务器端排序
				idField:'id', //主键字段
				queryParams:{}, //查询条件
				pagination:true, //显示分页
				rownumbers:true, //显示行号
				columns:[[
					{field:'ck',checkbox:true,width:2}, //显示复选框
					{field:'memberhead',title:'头像',width:8,sortable:false,align:'center',
						formatter:function(value,row,index){
							if(row.headurl){
								return "<img onclick='showImg(this)' src='"+row.headurl+"' width='20' height='20'/>";
							}
							else{
								return "";	
							}
						} 
					},
					{field:'membernickname',title:'会员昵称',width:30,sortable:false,align:'center',
						formatter:function(value,row,index){return row.nickname;}
					},
					{field:'name',title:'姓名',width:20,sortable:false,align:'center'},
					{field:'sex',title:'性别',width:20,sortable:false,align:'center',
						formatter:function(value,row,index){
							return row.sex=='0'?'男':'女';
						}
					},
					{field:'birthday',title:'生日',width:30,sortable:false,align:'center',
						formatter:function(value,row,index){
							return formatdate(row.birthday);
						}
					},
					{field:'phone',title:'电话',width:30,sortable:false,align:'center'},
					{field:'memberpoint',title:'会员积分',width:20,sortable:false,align:'center',
						formatter:function(value,row,index){
							return "<a href='${ctx}/pointLog/initPointLogList.action?memberid="+row.id+"'>"+row.memberpoint+"</a>";
						}
					},
					{field:'balance',title:'余额',width:20,sortable:false,align:'center',
						formatter:function(value,row,index){
							return row.balance;
						}
					},
					{field:'memberlevel',title:'等级',width:20,sortable:false,align:'center',
						formatter:function(value,row,index){
							return row.memberlevel;
						}
					},
					{field:'discount',title:'折扣',width:20,sortable:false,align:'center',
						formatter:function(value,row,index){
							return row.discount;
						}
					},
					{field:'fromname',title:'推荐人',width:30,sortable:false,align:'center',
						formatter:function(value,row,index){
							if(row.fromuser==0){
								return "无";
							}
							else{
								return row.fromname;
							}
						}
					},
					{field:'downCount',title:'推荐数量',width:20,sortable:false,align:'center'},
					{field:'status',title:'状态',width:20,sortable:false,align:'center',
						formatter:function(value,row,index){
							if(row.status=="0"){
								return "关注";
							}
							else if(row.status=="1"){
								return "取消关注";
							}
							else if(row.status=="2"){
								return "禁用";
							}
						}
					},
					{field:'registertime',title:'关注时间',width:30,sortable:false,align:'center',
						formatter:function(value,row,index){
							return formatdate(row.registertime);
						}
					},
					{field:'options',title:'操作',width:80,sortable:false,align:'center',
						formatter:function(value,row,index){
							var html="<a class='trbutton' href=\"javascript:updateMember("+row.id+")\">更新</a>&nbsp;";
							html+="|&nbsp;<a class='trbutton' href=\"javascript:addPoints("+row.id+","+row.memberpoint+")\"><img src='${ctx}/js/easyui/themes/icons/edit_add.png'/>积分</a>";
							html+="|&nbsp;<a class='trbutton' href=\"javascript:reducePoints("+row.id+","+row.memberpoint+")\"><img src='${ctx}/js/easyui/themes/icons/edit_remove.png'/>积分</a>";
							html+="|&nbsp;<a class='trbutton' href=\"javascript:recharge("+row.id+")\">充值</a>";
							return html;
						}
					}
				]],
				toolbar:[
			         {
						text:'充值记录',
						iconCls:'icon-search',
						handler:function(){
							chargeRecord();
						}
					}
			         ,"-",
			         {
						text:'类型变更记录',
						iconCls:'icon-search',
						handler:function(){
							typechangeRecord();
						}
					}
			         ,"-",
			         {
						text:'会员标签',
						iconCls:'icon-large-smartart',
						handler:function(){
							memberLabel();
						}
					}
				],
				onLoadSuccess:function(){
					$('#dataTable').datagrid('clearSelections');
				}
			});
			
		});
		
		
			//表格查询
	function searchList(){
		var params = $('#dataTable').datagrid('options').queryParams; //先取得 datagrid 的查询参数
		var fields =$('#queryForm').serializeArray(); //自动序列化表单元素为JSON对象
		$.each( fields, function(i, field){
			params[field.name] = field.value; //设置查询参数
		});
		$('#dataTable').datagrid('load'); //设置好查询参数 reload 一下就可以了
	}
			
	function updateMember(id){
		$('#dialog').dialog({
		    title: '更新会员',
		    width: 650,
		    height: 400,
		    closed: false,
		    cache: false,
		    href: '<%=request.getContextPath()%>/member/initMemberEdit.action?id='+id,
		    modal: true
		});
	}
	
	//增加积分
	function addPoints(id,points){
		$.messager.prompt('增加积分', '请输入要增加积分数量:', function(value){
			if (value){
				if(isNaN(value)){
					$.messager.alert('提示','请输入数字!','info');
					return;
				}
				$.ajax({
					url:'${ctx}/member/changePoints.action',
					data:{
						id:id,
						points:value,
						type:0
					},
					type:'POST',
					success:function(data){
						$.messager.alert('提示',data,'info');
						searchList();
					}
				});
			}
		});
	}
	
	//减少积分
	function reducePoints(id,points){
		$.messager.prompt('减少积分', '请输入要减少积分数量:', function(value){
			if (value){
				if(isNaN(value)){
					$.messager.alert('提示','请输入数字!','info');
					return;
				}
				if(parseInt(value)>points){
					$.messager.alert('提示','不能大于会员当前积分!','info');
					return;
				}
				$.ajax({
					url:'${ctx}/member/changePoints.action',
					data:{
						id:id,
						points:value,
						type:1
					},
					type:'POST',
					success:function(data){
						$.messager.alert('提示',data,'info');
						searchList();
					}
				});
			}
		});
	}
	
	function recharge(id){
		$('#dialog').dialog({
		    title: '会员充值',
		    width: 650,
		    height: 400,
		    closed: false,
		    cache: false,
		    href: '<%=request.getContextPath()%>/member/initRecharge.action?id='+id,
		    modal: true
		});
	}
	
	function chargeRecord(){
		var rows = $('#dataTable').datagrid('getSelections');
		if(rows.length==0){
			$.messager.alert('提示',"请选择你要查看的会员",'info');
			return;
		}
		if(rows.length > 1){
			$.messager.alert('提示',"只能选择一位会员进行查看",'info');
			return;
		}
		var row=$('#dataTable').datagrid('getSelected');
		$('#dialog').dialog({
		    title: '充值记录',
		    width: 950,
		    height: 450,
		    closed: false,
		    cache: false,
		    href: '<%=request.getContextPath()%>/member/initRechargeRecord.action?id='+row.id,
		    modal: true
		});
	}
	
	function memberLabel(){
		var rows = $('#dataTable').datagrid('getSelections');
		if(rows.length==0){
			$.messager.alert('提示',"请选择会员",'info');
			return;
		}
		if(rows.length > 1){
			$.messager.alert('提示',"只能选择一位会员",'info');
			return;
		}
		var row=$('#dataTable').datagrid('getSelected');
		$('#dialog').dialog({
		    title: '会员标签',
		    width: 950,
		    height: 450,
		    closed: false,
		    cache: false,
		    href: '<%=request.getContextPath()%>/member/initMemberLabels.action?id='+row.id,
		    modal: true
		});
	}
	
	
	function typechangeRecord(){
		var rows = $('#dataTable').datagrid('getSelections');
		if(rows.length==0){
			$.messager.alert('提示',"请选择你要查看的会员",'info');
			return;
		}
		if(rows.length > 1){
			$.messager.alert('提示',"只能选择一位会员进行查看",'info');
			return;
		}
		var row=$('#dataTable').datagrid('getSelected');
		$('#dialog').dialog({
		    title: '类型变更记录',
		    width: 950,
		    height: 450,
		    closed: false,
		    cache: false,
		    href: '<%=request.getContextPath()%>/member/initTypeChangeRecord.action?id='+row.id,
		    modal: true
		});
	}
		
	//清空查询条件
	function clearForm(){
		$('#queryForm').form('clear');
		searchList();
	}
	</script>
  </head>
  
  <body>
    <form action="" method="post" id="queryForm">
  		<table border="0">
  			<tr>
  				<td align="right" width="10%">会员昵称:</td>
  				<td align="left" width="20%"><input type="text" name="nickname" id="nickname"/></td>
  				<td align="right" width="10%">会员手机:</td>
  				<td align="left" width="20%"><input type="text" name="phone" id="phone"/></td>
  				<td align="right" width="10%">会员姓名:</td>
  				<td align="left" width="20%"><input type="text" name="name" id="name"/></td>
  			</tr>
  			<tr>
  				<td align="right" width="10%">推荐人:</td>
  				<td align="left" width="15%"><input type="text" name="fromname" id="fromname"/></td>
  				<td align="right" width="10%">生日月份:</td>
  				<td align="left" width="15%">
  					<select name="month" class="easyui-combobox" data-options="editable:false,onChange:function(){searchList()}">
  						<option value="">请选择生日月份</option>
  						<c:forEach begin="1" end="12" var="m">
  						<option value="${m }">${m }</option>
  						</c:forEach>
  					</select>
  				</td>
  				<td align="left" width="10%" colspan="1">
  					<select name="orderBy" class="easyui-combobox" data-options="editable:false,onChange:function(){searchList()}">
  						<option value="">请选择排序</option>
  						<option value="registertime desc">关注时间倒序</option>
  						<option value="memberpoint desc">积分倒序</option>
  					</select>
  				</td>
  				<td width="25%">
  					<a id="clearBtn" href="javascript:void(0)" class="easyui-linkbutton" onclick="clearForm()" data-options="iconCls:'icon-clear2'">清空</a>
  					<a id="searchBtn" href="javascript:void(0)" class="easyui-linkbutton" onclick="searchList()" data-options="iconCls:'icon-search'">查询</a>
  			    </td>
  			</tr>
  		</table>
  	</form>
  	<div class="tableDiv" style="padding: 5px;">
  		<table id="dataTable"></table>
  	</div>
  	<div id="dialog" style="padding: 5px;">   
	</div> 
  </body>
</html>
