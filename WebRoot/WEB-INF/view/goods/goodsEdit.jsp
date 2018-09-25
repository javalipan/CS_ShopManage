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
				if(!details.eq(i).hasClass("notChange")){
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
				else{
					detailArray.push({
						id:details.eq(i).attr("js-value"),
						color:details.eq(i).children().eq(1).attr("specid"),
						size:details.eq(i).children().eq(2).attr("specid"),
						code:details.eq(i).children().eq(3).find("input").val(),
						costprice:details.eq(i).children().eq(4).find("input").val(),
						oldprice:details.eq(i).children().eq(5).find("input").val(),
						price:details.eq(i).children().eq(6).find("input").val(),
						vipprice:details.eq(i).children().eq(7).find("input").val(),
						status:details.eq(i).children().eq(9).find("input").is(":checked")?1:0
					});
				}
			}
			$("input[name='detailJson']").val(JSON.stringify(detailArray));
			$.post("<%=request.getContextPath()%>/goods/saveGoods.action",$("#form1").serializeArray(),function(data){
				$.messager.alert('提示',data,'info',function(){
					if(window.parent&&parent.closeTabAndOpen){
						parent.closeTabAndOpen("商品编辑","商品管理","${ctx}/goods/initGoodsList.action");
					}else{
						location.href='${ctx}/goods/initGoodsList.action';
					}
				});
			});
		}
		
		var ue;
		$(function(){
			ue=UE.getEditor('ueditor',{initialFrameWidth :$(window).width()-200,initialFrameHeight :300,wordCount:false});
			ue.ready(function() {
				ue.setContent('${goods.intro }');
			});
			$(".window").css("zIndex",9);
			$(".window-shadow").css("zIndex",8);
			$(".window-mask").css("zIndex",7);
			
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
			    },
			    onLoadSuccess:function(){
			    	$("#typeid").combotree("setValue","${goods.typeid}");
			    }
			});
			
			$("#styletypeid").combotree({
				url:'${ctx}/style/searchStyleData.action',
				required:true,
				onSelect : function(node) {  
			    },
			    onLoadSuccess:function(){
			    	$("#styletypeid").combotree("setValue","${goods.styletypeid}");
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
					<input name="code" type="text" id="code" readonly="readonly" value="${goods.code}" data-options="required:true,validType:['length[1,50]']" class="easyui-validatebox"/>
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
							<option <c:if test="${brand.id==goods.brandid }">selected="selected"</c:if> value="${brand.id }">${brand.name }</option>
						</c:forEach>
					</select>
				</div>
			</div>
			<div class="item">
				<div class="label"><span style="color:red">*</span>单位:</div>
				<div class="input">
					<select name="unit" class="easyui-combobox" data-options="editable:false,width:147">
						<c:forEach items="${units }" var="unit">
							<option <c:if test="${unit.name==goods.unit }">selected="selected"</c:if> value="${unit.name }">${unit.name }</option>
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
					<label><input type="radio" name="isnew" value="0" <c:if test="${goods.isnew==null || goods.isnew=='0' }">checked="checked"</c:if> />否</label>
					<label><input type="radio" name="isnew" <c:if test="${goods.isnew=='1' }">checked="checked"</c:if> value="1"/>是</label>
				</div>
			</div>
			<div class="item">
				<div class="label"><span style="color:red">*</span>适用性别:</div>
				<div class="input">
					<label><input type="radio" name="sex" <c:if test="${goods.sex=='1' }">checked="checked"</c:if> value="1"/>女性</label>
					<label><input type="radio" name="sex" <c:if test="${goods.sex=='0' }">checked="checked"</c:if> value="0"/>男性</label>
					<label><input type="radio" name="sex" <c:if test="${goods.sex=='2' }">checked="checked"</c:if> value="2"/>所有</label>
				</div>
			</div>
			<div class="item">
				<div class="label"><span style="color:red">*</span>主要材质:</div>
				<div class="input">
					<select name="material" class="easyui-combobox" data-options="editable:false,width:147">
						<c:forEach items="${materials }" var="material">
							<option <c:if test="${material.name==goods.material }">selected="selected"</c:if> value="${material.name }">${material.name }</option>
						</c:forEach>
					</select>
				</div>
			</div>
			<div class="item">
				<div class="label"><span style="color:red">*</span>执行标准:</div>
				<div class="input">
					<select name="standard" class="easyui-combobox" data-options="editable:false,width:147">
						<c:forEach items="${standards }" var="standard">
							<option <c:if test="${standard.name==goods.standard }">selected="selected"</c:if> value="${standard.name }">${standard.name }</option>
						</c:forEach>
					</select>
				</div>
			</div>
			<div class="item">
				<div class="label">年:</div>
				<div class="input">
					<c:set var="flag" value="true"></c:set>
					<select name="goodsyear" class="easyui-combobox" data-options="editable:false,width:147">
						<c:forEach begin="${year }" end="${year+10 }" varStatus="status" var="y">
							<c:if test="${y==goods.goodsyear }"><c:set var="flag" value="false"></c:set></c:if>
						</c:forEach>
						<c:if test="${flag==true }">
							<option selected="selected" value="${goods.goodsyear }">${goods.goodsyear }</option>
						</c:if>
						<c:forEach begin="${year }" end="${year+10 }" varStatus="status" var="y">
							<option <c:if test="${y==goods.goodsyear }">selected="selected"</c:if> value="${y }">${y }</option>
						</c:forEach>
					</select>
				</div>
			</div>
			<div class="item">
				<div class="label"><span style="color:red">*</span>季节:</div>
				<div class="input">
					<select name="season" class="easyui-combobox" data-options="editable:false,width:147">
						<option <c:if test="${goods.season=='0' }">selected="selected"</c:if> value="0">春装</option>
						<option <c:if test="${goods.season=='1' }">selected="selected"</c:if> value="1">夏装</option>
						<option <c:if test="${goods.season=='2' }">selected="selected"</c:if> value="2">秋装</option>
						<option <c:if test="${goods.season=='3' }">selected="selected"</c:if> value="3">冬装</option>
					</select>
				</div>
			</div>
			<div class="item">
				<div class="label">到货方式${goods.stocktype }:</div>
				<div class="input">
					<select name="stocktype" class="easyui-combobox" data-options="editable:false,width:147">
						<option <c:if test="${goods.stocktype=='买断' }">selected="selected"</c:if> value="买断">买断</option>
						<option <c:if test="${goods.stocktype=='寄卖' }">selected="selected"</c:if> value="寄卖">寄卖</option>
						<option <c:if test="${goods.stocktype=='推广' }">selected="selected"</c:if> value="推广">推广</option>
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
			<c:forEach items="${imgs }" var="img" varStatus="status">
			<div class="item uploaditem">
				<div class="label">图片:</div>
				<div class="input">
					<img src="${ftppath }${img.path}" onerror="defaultImg(this)" onclick='showImg(this)' id="img${status.index+1 }" width="90" height="90"/>
					<c:if test="${status.index==0 }">
					<a href="javascript:void(0)" onclick="addUpload(this)"><img src="${ctx }/images/add.png"/></a>
					</c:if>
					<c:if test="${status.index!=0 }">
					<a href="javascript:void(0)" onclick="removeUpload(this)"><img src="${ctx }/images/remove.png"/></a>
					</c:if>
					<input type="file" class="imgupload" name="file${status.index+1 }" accept="image/png,image/gif,image/jpg,image/jpeg" onchange="upload(this,'img${status.index+1 }','img${status.index+1 }')" id="typeicon${status.index+1 }"/>
					<input type="hidden" name="img${status.index+1 }" value="${img.path }"/>
				</div>
			</div>
			</c:forEach>
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
									<c:set var="flag" value="off"></c:set>
									<c:forEach items="${details }" var="detail">
										<c:if test="${detail.colorid==color.id }">
											<c:set var="flag" value="on notChange"></c:set>
										</c:if>
									</c:forEach>
									<li class="${flag }" onclick="clickSpecValue(this);" js-code="${color.code }" js-value="${color.id }">${color.specvalue }</li>
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
									<c:set var="flag" value="off"></c:set>
									<c:forEach items="${details }" var="detail">
										<c:if test="${detail.sizeid==size.id }">
											<c:set var="flag" value="on notChange"></c:set>
										</c:if>
									</c:forEach>
									<li class="${flag }" onclick="clickSpecValue(this);" js-code="${size.code }" js-value="${size.id }">${size.specvalue }</li>
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
						<c:forEach items="${details }" var="detail" varStatus="status">
							<tr class="notChange" js-value="${detail.id }" id="color-${detail.colorid }_size-${detail.sizeid }_">
								<td>${status.index+1 }</td>
								<td code="<c:forEach items="${colors }" var="color"><c:if test="${color.id==detail.colorid }">${color.code }</c:if></c:forEach>" specid="${detail.colorid }">${detail.colorName }</td>
								<td code="<c:forEach items="${sizes }" var="size"><c:if test="${size.id==detail.sizeid }">${size.code }</c:if></c:forEach>" specid="${detail.sizeid }">${detail.sizeName }</td>
								<td><input type="text" readonly="readonly" value="${detail.detailcode }" class="easyui-validatebox validatebox-text validatebox-invalid" data-options="required:true,validType:['moreThanZero']"></td>
								<td><c:if test="${showcost=='false' }">--</c:if><input type="text" <c:if test="${showcost=='false' }">style="display:none"</c:if> value="${detail.costprice }" style="width: 80px;" class="easyui-validatebox validatebox-text validatebox-invalid" data-options="required:true,validType:['moreThanZero']"></td>
								<td><input type="text" value="${detail.oldprice }" style="width: 80px;" class="easyui-validatebox validatebox-text validatebox-invalid" data-options="required:true,validType:['moreThanZero']"></td>
								<td><input type="text" value="${detail.price }" style="width: 80px;" class="easyui-validatebox validatebox-text validatebox-invalid" data-options="required:true,validType:['moreThanZero']"></td>
								<td><input type="text" value="${detail.vipprice }" style="width: 80px;" class="easyui-validatebox validatebox-text validatebox-invalid" data-options="required:true,validType:['moreThanZero']"></td>
								<td>${detail.amount }</td>
								<td>
									<c:choose>
										<c:when test="${detail.status=='1' }">
											<input type="checkbox" checked="checked"/>
										</c:when>
										<c:otherwise>
											<input type="checkbox"/>
										</c:otherwise>
									</c:choose>
								</td>
								<td></td>
							</tr>
						</c:forEach>
					</tbody>
				</table>
			</div>
			
			<div class="item full clearfix">
				<div class="label">详细介绍:</div>
				<div class="input">
					<script id="ueditor" name="intro"></script>
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
