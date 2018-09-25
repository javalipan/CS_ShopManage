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
    <title>联名合作编辑</title>
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
  </head>
  
  <body>
	<script type="text/javascript">
		function saveContent(){
			var flag = $('#form1').form('validate');
			if(!flag) {
				return false;
			}
			var array=[];
			for(var j=0;j<$(".goodsitem").length;j++){
				array.push($(".goodsitem").eq(j).find("input[name='goodsid']").val());
			}
			if(array.length<=0){
				$.messager.alert('提示',"请先选择商品",'info');
				return;
			}
			$("input[name='json']").val(JSON.stringify(array));
			$.post("<%=request.getContextPath()%>/coo/saveCooperate.action",$("#form1").serializeArray(),function(data){
				var url="${ctx}/coo/initCooperateList.action";
				if(window.parent&&parent.closeTabAndOpen){
					parent.closeTabAndOpen("联名合作编辑","联名合作管理",url);
				}else{
					location.href=url;
				}
			});
		}
		
		function upload(t,obj1,obj2){
			var id=$(t).attr("id");
			$.ajaxFileUpload({
                url: '${ctx}/attachment/uploadFile.action', //用于文件上传的服务器端请求地址
                secureuri: false, //是否需要安全协议，一般设置为false
                fileElementId: id, //文件上传域的ID
                dataType: 'json', //返回值类型 一般设置为json
                success: function (data, status)  //服务器成功响应处理函数
                {
                    $("#"+obj1).attr("src", "${basePath}"+data.filePath);
                    $("input[name='"+obj2+"']").val(data.filePath);
                },
                error: function (data, status, e)//服务器响应失败处理函数
                {
                    alert(e);
                }
            });
		}
		
		function selectGoods(){
			var rows=$('#goodsTable').datagrid("getChecked");
			var html="";
			for(var i=0;i<rows.length;i++){
				var flag=true;
				for(var j=0;j<$(".goodsitem").length;j++){
					if($(".goodsitem").eq(j).find("input[name='goodsid']").val()==rows[i].id){
						flag=false;
					}
				}
				if(flag){
					html+="<div class='left goodsitem'>"
						+"<input type='hidden' name='goodsid' value='"+rows[i].id+"'/><div class='img'><img src='${ftppath}"+rows[i].img+"' onclick='showImg(this)' onerror='defaultImg(this)' id='img' width='90' height='90'/></div>"
						+"<div class='goodsname'><span>"+rows[i].name+"</span></div>"
						+"<div class='del'>删除</div>"
						+"</div>";
				}
			}
			$("#goodsitems").append(html);
			$("#goodsDialog").dialog('close');
		}
		
		var ue;
		$(function(){
			ue=UE.getEditor('ueditor',{initialFrameWidth :($(window).width()-130),initialFrameHeight :300,wordCount:false});
			ue.ready(function() {
				ue.setContent('${cooperate.content }');
			});
			$(".window").css("zIndex",9);
			$(".window-shadow").css("zIndex",8);
			$(".window-mask").css("zIndex",7);
			$("#goodsDialog").dialog({
			    title: '选择商品',
			    width: 750,
			    height: 450,
			    closed: true,
			    cache: false,
			    modal: true
			});
			
			$("#addGoods").click(function(){
				$("#goodsDialog").dialog('open');
				
				$('#goodsTable').datagrid({
					iconCls:'icon-list', //图标
					singleSelect:false, //多选
					nowrap: true,// True 就会把数据显示在一行里。
					autoRowHeight: false, // 自动调整行高
					fitColumns: true, //自动调整各列，用了这个属性，下面各列的宽度值就只是一个比例。
					striped: true, //奇偶行颜色不同
					url:"<%=request.getContextPath()%>/goods/searchGoodss.action", //数据来源
					collapsible:true,//可折叠
					idField:'id', //主键字段
					rownumbers:true, //显示行号
					idField:'id', //主键字段
					queryParams:{
						status:1,
						brandType:1
					}, //查询条件
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
								return "<a class='trbutton' target='_blank' href='${ctx}/goods/initGoodsDetail.action?id="+row.id+"'>"+row.code+"</a>";
							} 
						},
						{field:'brandname',title:'品牌名称',width:60,sortable:false,align:'center',
							formatter:function(value,row,index){return row.brandname;}
						},
						{field:'name',title:'名称',width:60,sortable:false,align:'center',
							formatter:function(value,row,index){return row.name;}
						},
						{field:'createtime',title:'创建时间',width:60,sortable:false,align:'center',
							formatter:function(value,row,index){
								return formatdate(row.createtime);
							} 
						},
						{field:'updatetime',title:'更新时间',width:60,sortable:false,align:'center',
							formatter:function(value,row,index){
								return formatdate(row.updatetime);
							} 
						}
					]],
					onLoadSuccess:function(){
						$('#goodsTable').datagrid('clearSelections');
					}
				});
			});
			
			$(".item").on("mouseenter",".goodsitem",function(){
				$(this).find(".del").show();
			});
			$(".item").on("mouseleave",".goodsitem",function(){
				$(this).find(".del").hide();
			});
			
			$(".item").on("click",".del",function(){
				$(this).parent().remove();
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
			$("#status").val(1);
			$("#brandType").val(1);
			searchGoods();
		}
	</script>
  	<form name="form1" method="post" id="form1" class="l-form">
		<input type="hidden" name="id" value="${cooperate.id}"/>
		<input type="hidden" name="json"/>
		<div class="title">
			<div class="icon"><img src='<c:url value="/images/info.png"></c:url>' width="20"/></div>
			<span>联名合作信息</span>
		</div>
		<div class="formitems">
			<div class="item">
				<div class="label"><span style="color:red">*</span>标题:</div>
				<div class="input">
					<input name="title" type="text" id="title" value="${cooperate.title}" data-options="required:true,validType:['length[1,50]']" class="easyui-validatebox"/>
				</div>
			</div>
			<div class="item">
				<div class="label">图片:</div>
				<div class="input">
					<img src="${basePath }${cooperate.img}" onclick='showImg(this)' onerror="defaultImg(this)" id="img" width="90" height="90"/>
					<input type="file" class="imgupload" name="file1" accept="image/png,image/gif,image/jpg,image/jpeg" onchange="upload(this,'img','img')" id="typeicon"/>
					<input type="hidden" name="img" value="${cooperate.img }"/>
				</div>
			</div>
			<div class="item full">
				<div class="label">内容:</div>
				<div class="input">
					<script id="ueditor" name="content" style="height:100%;"></script>
				</div>
			</div>
			<div class="item full">
				<div class="label">&nbsp;</div>
				<a id="addGoods" href="javascript:void(0)" class="easyui-linkbutton" data-options="iconCls:'icon-add'">添加商品</a>  
			</div>
			<div class="item full">
				<div class="label">&nbsp;</div>
				<div class="left" id="goodsitems">
					<c:forEach items="${goods }" var="g">
						<div class="left goodsitem">
							<input type='hidden' name='goodsid' value="${g.id }"/>
							<div class="img"><img src="${ftppath }${g.img}" onclick='showImg(this)' onerror="defaultImg(this)" id="img" width="90" height="90"/></div>
							<div class="goodsname"><span>${g.name }</span></div>
							<div class="del">删除</div>
						</div>
					</c:forEach>
				</div>
			</div>
			<div style="clear:both;"></div>
		</div>
		<div class="btnDiv">
			<a id="saveBtn" href="javascript:void(0);" onclick="saveContent()" class="easyui-linkbutton" data-options="iconCls:'icon-save'">保存</a>
		</div>
	</form>
	
	<div id="goodsDialog" style="padding: 5px;">
		<form action="" method="post" id="queryForm">
			<input type="hidden" name="status" id="status" value="1"/>
			<input type="hidden" name="brandType" id="brandType" value="1"/>
	  		<table border="0">
	  			<tr>
	  				<td align="right" width="10%">品牌名称:</td>
	  				<td align="left" width="20%"><input type="text" name="brandname" id="brandname"/></td>
	  				<td align="right" width="10%">编码:</td>
	  				<td align="left" width="20%"><input type="text" name="code" id="code"/></td>
	  				<td align="right" width="10%">名称:</td>
	  				<td align="left" width="20%"><input type="text" name="name" id="name"/></td>
	  			</tr>
	  			<tr>
	  				<td width="30%" colspan="5">
	  				</td>
	  				<td width="30%" colspan="1">
	  					<a id="clearBtn" href="javascript:void(0)" class="easyui-linkbutton" onclick="clearForm()" data-options="iconCls:'icon-clear2'">清空</a>
	  					<a id="searchBtn" href="javascript:void(0)" class="easyui-linkbutton" onclick="searchGoods()" data-options="iconCls:'icon-search'">查询</a>
	  			    </td>
	  			</tr>
	  		</table>
	  	</form>
		<table id="goodsTable" width="100%">
		</table>
		<div class="btnDiv">
			<a id="saveBtn" href="javascript:void(0);" onclick="selectGoods()" class="easyui-linkbutton" data-options="iconCls:'icon-ok'">确定</a>
		</div>
	</div>
  </body>
</html>
