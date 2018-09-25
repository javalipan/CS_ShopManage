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
    <title>商品编辑</title>
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
	<script type="text/javascript" src="${ctx }/js/goods.js"></script>
  </head>
  
  <body>
	<script type="text/javascript">
		function saveGoods(){
			var flag = $('#form1').form('validate');
			if(!flag) {
				return false;
			}
			var imgarray=[];
			for(var i=0;i<$(".uploaditem").length;i++){
				var url=$(".uploaditem").eq(i).find("input[type='hidden']").val();
				if(url){
					imgarray.push(url);
				}
			}
			if(imgarray.length<=0){
				$.messager.alert('提示','请上传图片','info');
				return false;
			}
			$("input[name='imgJson']").val(JSON.stringify(imgarray));
			var details=$("#dptable tbody").children();
			var detailArray=[];
			for(var i=0;i<details.length;i++){
				detailArray.push({
					color:details.eq(i).children().eq(1).attr("specid"),
					size:details.eq(i).children().eq(2).attr("specid"),
					code:details.eq(i).children().eq(3).find("input").val(),
					costprice:details.eq(i).children().eq(4).find("input").val(),
					oldprice:details.eq(i).children().eq(5).find("input").val(),
					price:details.eq(i).children().eq(6).find("input").val(),
					vipprice:details.eq(i).children().eq(7).find("input").val(),
					amount:details.eq(i).children().eq(8).find("input").val(),
					status:details.eq(i).children().eq(9).find("input").is(":checked")?1:0
				});
			}
			if(detailArray.length<=0){
				$.messager.alert('提示','请选择商品规格','info');
				return false;
			}
			$("input[name='detailJson']").val(JSON.stringify(detailArray));
			$.post("<%=request.getContextPath()%>/goods/saveGoods.action",$("#form1").serializeArray(),function(data){
				$.messager.alert('提示',data,'info',function(){
					if(window.parent&&parent.closeTabAndOpen){
						parent.closeTabAndOpen("商品新增","商品管理","${ctx}/goods/initGoodsList.action");
					}else{
						location.href='${ctx}/goods/initGoodsList.action';
					}
				});
			}); 
		}
		
		function codeExists(value){
			var result = $.ajax({
			    url:'<%=request.getContextPath()%>/goods/codeExists.do?code='+value,
			    async:false,
			    cache:false,
			    dataType:"text"
				}).responseText;
				if(result.charCodeAt()=="true".charCodeAt()){
					return false;
				}
				else{
					return true;
				}
		}
		
		$(function(){
			UE.getEditor('ueditor',{initialFrameWidth :$(window).width()-200,initialFrameHeight :300,wordCount:false});
			$(".window").css("zIndex",9);
			$(".window-shadow").css("zIndex",8);
			$(".window-mask").css("zIndex",7);
			
			$.extend($.fn.validatebox.defaults.rules, {
				codeExists: {
			        validator: function (value, param) {
			            return codeExists(value);
			        },
			        message: '商品编码重复,请重新输入!'
			    }
			});
			
			$("input[name='code']").focus();
			
			$("#typeid").combotree({
				url:'${ctx}/type/searchTypeData.action',
				required:true,
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
			        	generateCode();
			        }
			    }
			});
			
			$("#styletypeid").combotree({
				url:'${ctx}/style/searchStyleData.action',
				required:true,
				onSelect : function(node) {  
			    }
			});
			
			$("input[name='sex']").change(function(){
				generateCode();
			});
		}); 
	</script>
  	<form name="form1" method="post" id="form1" class="l-form">
		<input type="hidden" name="imgJson"/>
		<input type="hidden" name="detailJson"/>
		<input type="hidden" name="id" value="${goods.id}"/>
		<div class="title">
			<div class="icon"><img src='<c:url value="/images/info.png"></c:url>' width="20"/></div>
			<span>商品信息</span>
		</div>
		<div class="formitems">
			<div class="item">
				<div class="label"><span style="color:red">*</span>商品编码:</div>
				<div class="input">
					<input name="code" type="text" id="code" value="${goods.code}" data-options="required:true,validType:['length[1,50]','codeExists']" class="easyui-validatebox"/>
				</div>
			</div>
			<div class="item" style="width:600px;">
				<div class="label"><span style="color:red">*</span>名称:</div>
				<div class="input" style="width:525px;">
					<input name="name" type="text" style="width: 431px;" id="name" value="${goods.name}" data-options="required:true,validType:['length[1,50]']" class="easyui-validatebox"/>
				</div>
			</div>
			<div class="item">
				<div class="label"><span style="color:red">*</span>商品风格:</div>
				<div class="input">
					<input type="text" name="styletypeid" id="styletypeid"/>
				</div>
			</div>
			<div class="item">
				<div class="label"><span style="color:red">*</span>商品分类:</div>
				<div class="input">
					<input type="text" name="typeid" id="typeid"/>
				</div>
			</div>
			<div class="item">
				<div class="label"><span style="color:red">*</span>品牌:</div>
				<div class="input">
					<select name="brandid" class="easyui-combobox" data-options="editable:false,width:147">
						<c:forEach items="${brands }" var="brand">
							<option value="${brand.id }">${brand.name }</option>
						</c:forEach>
					</select>
				</div>
			</div>
			<div class="item">
				<div class="label"><span style="color:red">*</span>单位:</div>
				<div class="input">
					<select name="unit" class="easyui-combobox" data-options="editable:false,width:147">
						<c:forEach items="${units }" var="unit">
							<option value="${unit.name }">${unit.name }</option>
						</c:forEach>
					</select>
				</div>
			</div>
			<div class="item">
				<div class="label"><span style="color:red">*</span>首页推荐:</div>
				<div class="input">
					<label><input type="radio" name="isrecomment" value="0" <c:if test="${goods.isrecomment==null || goods.isrecomment=='0' }">checked="checked"</c:if>/>否</label>
					<label><input type="radio" name="isrecomment" <c:if test="${goods.isrecomment=='1' }">checked="checked"</c:if> value="1"/>是</label>
				</div>
			</div>
			<div class="item">
				<div class="label"><span style="color:red">*</span>是否新品:</div>
				<div class="input">
					<label><input type="radio" name="isnew" value="0" <c:if test="${goods.isnew==null || goods.isnew=='0' }">checked="checked"</c:if>/>否</label>
					<label><input type="radio" name="isnew" <c:if test="${goods.isnew=='1' }">checked="checked"</c:if> value="1"/>是</label>
				</div>
			</div>
			<div class="item">
				<div class="label"><span style="color:red">*</span>适用性别:</div>
				<div class="input">
					<label><input type="radio" name="sex" <c:if test="${goods.sex==null ||goods.sex=='1' }">checked="checked"</c:if> value="1"/>女性</label>
					<label><input type="radio" name="sex" value="0" <c:if test="${ goods.sex=='0' }">checked="checked"</c:if>/>男性</label>
					<label><input type="radio" name="sex" <c:if test="${goods.sex=='2' }">checked="checked"</c:if> value="2"/>所有</label>
				</div>
			</div>
			<div class="item">
				<div class="label"><span style="color:red">*</span>主要材质:</div>
				<div class="input">
					<select name="material" class="easyui-combobox" data-options="editable:false,width:147">
						<c:forEach items="${materials }" var="material">
							<option value="${material.name }">${material.name }</option>
						</c:forEach>
					</select>
				</div>
			</div>
			<div class="item">
				<div class="label"><span style="color:red">*</span>执行标准:</div>
				<div class="input">
					<select name="standard" class="easyui-combobox" data-options="editable:false,width:147">
						<c:forEach items="${standards }" var="standard">
							<option value="${standard.name }">${standard.name }</option>
						</c:forEach>
					</select>
				</div>
			</div>
			<div class="item">
				<div class="label">年:</div>
				<div class="input">
					<select name="goodsyear" class="easyui-combobox" data-options="editable:false,width:147">
						<c:forEach begin="${year }" end="${year+10 }" varStatus="status" var="y">
							<option value="${y }">${y }</option>
						</c:forEach>
					</select>
				</div>
			</div>
			<div class="item">
				<div class="label"><span style="color:red">*</span>季节:</div>
				<div class="input">
					<select name="season" class="easyui-combobox" data-options="editable:false,width:147,onChange:function(){generateCode()}">
						<option value="0">春装</option>
						<option value="1">夏装</option>
						<option value="2">秋装</option>
						<option value="3">冬装</option>
					</select>
				</div>
			</div>
			<div class="item">
				<div class="label">到货方式:</div>
				<div class="input">
					<select name="stocktype" class="easyui-combobox" data-options="editable:false,width:147">
						<option value="买断">买断</option>
						<option value="寄卖">寄卖</option>
						<option value="推广">推广</option>
					</select>
				</div>
			</div>
			
			<div class="item">
				<div class="label">生产地址:</div>
				<div class="input">
					<input name="productaddress" type="text" id="productaddress" value="${goods.productaddress}" data-options="validType:['length[1,50]']" class="easyui-validatebox"/>
				</div>
			</div>
			<div class="item">
				<div class="label"><span style="color:red">*</span>排序值:</div>
				<div class="input">
					<input name="sortno" type="text" id="sortno" <c:if test="${goods.id==null }">value="0"</c:if><c:if test="${goods.id!=null }">value="${goods.sortno}"</c:if> data-options="required:true,validType:['number']" class="easyui-validatebox"/>
				</div>
			</div>
			<div class="item">
				<div class="label">洗涤方式:</div>
				<div class="input">
					<input name="washway" type="text" id="washway" value="${goods.washway}" data-options="validType:['length[1,20]']" class="easyui-validatebox"/>
				</div>
			</div>
			<div class="item full">
				<div class="label">简介:</div>
				<div class="input">
					<textarea rows="5" cols="70" name="shortintro">${goods.shortintro }</textarea>
				</div>
			</div>
			<c:if test="${goods.id==null }">
				<div class="item uploaditem">
					<div class="label">图片:</div>
					<div class="input">
						<img src="${ctx }/images/noimg.jpg" onclick='showImg(this)' onerror="defaultImg(this)" id="img" width="90" height="90"/><a href="javascript:void(0)" onclick="addUpload(this)"><img src="${ctx }/images/add.png"/></a>
						<input type="file" class="imgupload" name="file1" accept="image/png,image/gif,image/jpg,image/jpeg" onchange="upload(this,'img','img')" id="typeicon"/>
						<input type="hidden" name="img" value="${goods.img }"/>
					</div>
				</div>
			</c:if>
			<c:if test="${goods.id!=null }">
				<c:forEach items="${imgs }" var="img" varStatus="status">
				<div class="item uploaditem">
					<div class="label">图片:</div>
					<div class="input">
						<img src="${ftppath }${img.path}" onclick='showImg(this)' onerror="defaultImg(this)" id="img" width="90" height="90"/>
						<c:if test="${status.index==0 }">
						<a href="javascript:void(0)" onclick="addUpload(this)"><img src="${ctx }/images/add.png"/></a>
						</c:if>
						<c:if test="${status.index!=0 }">
						<a href="javascript:void(0)" onclick="removeUpload(this)"><img src="${ctx }/images/remove.png"/></a>
						</c:if>
						<input type="file" class="imgupload" name="file1" accept="image/png,image/gif,image/jpg,image/jpeg" onchange="upload(this,'img','img')" id="typeicon"/>
						<input type="hidden" name="img" value="${img.path }"/>
					</div>
				</div>
				</c:forEach>
			</c:if>
			<div style="clear:both;"></div>
			<div class="product-type-right clearfix">
				<div class="product-type-left-title">规格值</div>
				<div class="dd-box">
					<div class="dd clearfix">
						<div class="guigeName">
							<label>颜色</label>
						</div>
						<div class="guigeName-product">
							<ul js-value="color">
								<c:forEach items="${colors }" var="color">
									<li class="off" onclick="clickSpecValue(this);" js-code="${color.code }" js-value="${color.id }">${color.specvalue }</li>
								</c:forEach>
							</ul>
						</div>
					</div>
					<div class="dd clearfix">
						<div class="guigeName">
							<label>尺码</label>
						</div>
						<div class="guigeName-product">
							<ul js-value="size">
								<c:forEach items="${sizes }" var="size">
									<li class="off" onclick="clickSpecValue(this);"js-code="${size.code }" js-value="${size.id }">${size.specvalue }</li>
								</c:forEach>
							</ul>
						</div>
					</div>
				</div>
			</div>

			<div class="tableDiv clearfix">
				<table class="table-product" id="dptable">
					<thead>
						<tr>
							<th>序号</th>
							<th>颜色</th>
							<th>尺寸</th>
							<th>条形码</th>
							<th>成本价</th>
							<th>吊牌价</th>
							<th>成交价</th>
							<th>折扣价</th>
							<th>库存数量</th>
							<th>是否上架</th>
							<th>操作</th>
						</tr>
					</thead>
					<tbody>
					</tbody>
				</table>
			</div>
			
			<div class="item full clearfix">
				<div class="label">详细介绍:</div>
				<div class="input">
					<script id="ueditor" name="intro">${goods.intro }</script>
				</div>
			</div>

			<div style="clear:both;"></div>
		</div> 
		<div class="btnDiv">
			<a id="saveBtn" href="javascript:void(0);" onclick="saveGoods()" class="easyui-linkbutton" data-options="iconCls:'icon-save'">保存</a>
			<a id="saveBtn" href="javascript:void(0);" onclick="location.href='${ctx}/goods/initGoodsList.action'" class="easyui-linkbutton" data-options="iconCls:'icon-back'">返回</a>
		</div>
	</form>
  </body>
</html>
