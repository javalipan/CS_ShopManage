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
    <title>商品详情</title>
	<meta http-equiv="pragma" content="no-cache">
	<meta http-equiv="cache-control" content="no-cache">
	<meta http-equiv="expires" content="0">    
	<meta http-equiv="keywords" content="keyword1,keyword2,keyword3">
	<meta http-equiv="description" content="This is my page">
	<meta http-equiv="X-UA-Compatible" content="IE=EmulateIE8"/>
	<jsp:include page="/tags.jsp"></jsp:include>
	<script type="text/javascript">
		function updateStatus(id,status){
			var tip="";
			if(status=='1'){
				tip="上架";
			}else{
				tip="下架";
			}
			$.messager.confirm('提示','您确认要'+tip+'选择项?',function(result){
		        if (result){
					$.ajax({
						url:"${ctx}/goods/updateDetailStatus.action",
						data:{
							id:id,
							status:status
						},
						success:function(data){
							$.messager.alert('提示',data,'info',function(){
								location.reload();
							});
						}
					});
		        }
			});
		}
	</script>
  </head>
  
  <body>
  	<form name="form1" method="post" id="form1" class="l-form">
		<div class="title">
			<div class="icon"><img src='<c:url value="/images/info.png"></c:url>' width="20"/></div>
			<span>商品信息</span>
		</div>
		<div class="formitems">
			<div class="item">
				<div class="label">商品编码:</div>
				<div class="input">${goods.code}</div>
			</div>
			<div class="item">
				<div class="label">名称:</div>
				<div class="input">
					${goods.name}
				</div>
			</div>
			<div class="item">
				<div class="label">风格:</div>
				<div class="input">
					${goods.styletypename }
				</div>
			</div>
			<div class="item">
				<div class="label">分类:</div>
				<div class="input">
					${goods.typename }
				</div>
			</div>
			<div class="item">
				<div class="label">品牌:</div>
				<div class="input">
					${goods.brandname }
				</div>
			</div>
			<div class="item">
				<div class="label">单位:</div>
				<div class="input">
					${goods.unit }
				</div>
			</div>
			<div class="item">
				<div class="label">首页推荐:</div>
				<div class="input">
					<c:if test="${goods.isrecomment=='0' }">否</c:if>
					<c:if test="${goods.isrecomment=='1' }">是</c:if>
				</div>
			</div>
			<div class="item">
				<div class="label">是否新品:</div>
				<div class="input">
					<c:if test="${goods.isnew=='0' }">否</c:if>
					<c:if test="${goods.isnew=='1' }">是</c:if>
				</div>
			</div>
			<div class="item">
				<div class="label">适用性别:</div>
				<div class="input">
					<c:if test="${goods.sex=='0' }">男性</c:if>
					<c:if test="${goods.sex=='1' }">女性</c:if>
					<c:if test="${goods.sex=='2' }">所有</c:if>
				</div>
			</div>
			<div class="item">
				<div class="label">主要材质:</div>
				<div class="input">
					${goods.material }
				</div>
			</div>
			<div class="item">
				<div class="label">执行标准:</div>
				<div class="input">
					${goods.standard }
				</div>
			</div>
			<div class="item">
				<div class="label">年:</div>
				<div class="input">
					${goods.goodsyear }
				</div>
			</div>
			<div class="item">
				<div class="label">季节:</div>
				<div class="input">
					<c:choose>
						<c:when test="${goods.season=='0' }">春季</c:when>
						<c:when test="${goods.season=='1' }">夏季</c:when>
						<c:when test="${goods.season=='2' }">秋季</c:when>
						<c:when test="${goods.season=='3' }">冬季</c:when>
					</c:choose>
				</div>
			</div>
			<div class="item">
				<div class="label">到货方式:</div>
				<div class="input">
					${goods.stocktype }
				</div>
			</div>
			<div class="item">
				<div class="label">生产地址:</div>
				<div class="input">
					${goods.productaddress}
				</div>
			</div>
			<div class="item">
				<div class="label">排序值:</div>
				<div class="input">
					${goods.sortno}
				</div>
			</div>
			<div class="item">
				<div class="label">洗涤方式:</div>
				<div class="input">
					${goods.washway}
				</div>
			</div>
			<div class="item full">
				<div class="label">简介:</div>
				<div class="input">
					${goods.shortintro }
				</div>
			</div>
			<div class="item uploaditem">
				<div class="label">图片:</div>
				<c:forEach items="${imgs }" var="img" varStatus="status">
					<img src="${ftppath }${img.path}" onclick='showImg(this)' onerror="defaultImg(this)" id="img" width="90" height="90"/>
				</c:forEach>
			</div>
			<div class="tableDiv clearfix">
				<table class="table-product" id="dptable">
					<thead>
						<tr>
							<th>序号</th>
							<th>颜色</th>
							<th>尺寸</th>
							<th>条形码</th>
							<th <c:if test="${showcost=='false' }">style="display:none"</c:if>>成本价</th>
							<th>吊牌价</th>
							<th>成交价</th>
							<th>折扣价</th>
							<th>库存量</th>
							<th>状态</th>
							<th>操作</th>
						</tr>
					</thead>
					<tbody>
						<c:forEach items="${details }" var="detail" varStatus="status">
							<tr class="notChange" id="color-${detail.colorid }_size-${detail.sizeid }_">
								<td>${status.index+1 }</td>
								<td specid="1">${detail.colorName }</td>
								<td specid="11">${detail.sizeName }</td>
								<td>${detail.detailcode }</td>
								<td <c:if test="${showcost=='false' }">style="display:none"</c:if>>${detail.costprice }</td>
								<td>${detail.oldprice }</td>
								<td>${detail.price }</td>
								<td>${detail.vipprice }</td>
								<td>${detail.amount }</td>
								<td>
									<c:choose>
										<c:when test="${detail.status=='0' }"><span class="red">未上架</span></c:when>
										<c:when test="${detail.status=='1' }"><span class="green">上架</span></c:when>
										<c:when test="${detail.status=='2' }"><span class="red">下架</span></c:when>
									</c:choose>
								</td>
								<td>
									<c:choose>
										<c:when test="${detail.status=='2'||detail.status=='0' }"><a href="javascript:void(0)" class='trbutton' onclick="updateStatus(${detail.id },'1')">上架</a></c:when>
										<c:otherwise><a href="javascript:void(0)" class='trbutton' onclick="updateStatus(${detail.id },'2')">下架</a></c:otherwise>
									</c:choose>
								</td>
							</tr>
						</c:forEach>
					</tbody>
				</table>
			</div>
			
			<div class="item full clearfix">
				<div class="label">详细介绍:</div>
				<div class="input">
					${goods.intro }
				</div>
			</div>

			<div style="clear:both;"></div>
		</div> 
		<div class="btnDiv">
			<a id="saveBtn" href="javascript:void(0);" onclick="location.href='${ctx}/goods/initGoodsList.action'" class="easyui-linkbutton" data-options="iconCls:'icon-back'">返回</a>
		</div>
	</form>
  </body>
</html>
