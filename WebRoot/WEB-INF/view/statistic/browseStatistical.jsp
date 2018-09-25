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
    <title>商品访问统计</title>
	<meta http-equiv="pragma" content="no-cache">
	<meta http-equiv="cache-control" content="no-cache">
	<meta http-equiv="expires" content="0">    
	<meta http-equiv="keywords" content="keyword1,keyword2,keyword3">
	<meta http-equiv="description" content="This is my page">
	<meta http-equiv="X-UA-Compatible" content="IE=EmulateIE8"/>
	<jsp:include page="/tags.jsp"></jsp:include>
	<script language="javascript" type="text/javascript" src="<%=request.getContextPath()%>/js/echarts.min.js"></script>
	<script type="text/javascript">
	var option = {
		    title : {
		        text: '商品浏览量统计',
		        subtext: '前20',
		        x:'center'
		    },
		    legend: {
		        type: 'scroll',
		        orient: 'vertical',
		        right: 10,
		        top: 20,
		        bottom: 20
		    },
		    tooltip : {
		        trigger: 'item',
		        formatter: "{a} <br/>{b} : {c} ({d}%)"
		    },
		    series : [
		        {
		            name: '浏览量',
		            type: 'pie',
		            radius : '55%',
		            center: ['40%', '50%'],
		            itemStyle: {
		                emphasis: {
		                    shadowBlur: 10,
		                    shadowOffsetX: 0,
		                    shadowColor: 'rgba(0, 0, 0, 0.5)'
		                }
		            }
		        }
		    ]
		};
	var myChart;
	
	$(function(){
	});
	
	function loadData(brandid){
		$.ajax({
			url:"${ctx}/statistic/browse/sumGoodsBrowse.action",
			dataType:"json",
			data:{
				brandid:brandid
			},
			success:function(data){
				if(data.length==0){
					$.messager.alert('提示',"暂无数据",'info');
				}
				else{
					option.series[0].data=data.seriesData;
					option.legend.data=data.legendData;
					myChart = echarts.init(document.getElementById('chart'));
					myChart.setOption(option,true);
				}
			}
		});
	}
	
	
	function brandChange(node){
		loadData(node.value)
	}
	</script>
  </head>
  
  <body>
  	<form action="" method="post" id="queryForm">
  		<table border="0">
			<tr>
				<td align="right" width="10%">品牌:</td>
  				<td align="left" width="40%" colspan="3">
  					<select id="brandid" class="easyui-combobox" data-options="editable:false,onSelect:brandChange">
  						<option value="">请选择品牌</option>
  						<c:forEach items="${brands }" var="brand">
  							<option value="${brand.id }">${brand.name }</option>
  						</c:forEach>
  					</select>
  				</td>
  			</tr>
  		</table>
  	</form>
  	<div class="tableDiv" style="padding: 5px;">
	  	<div id="chart" style="min-height: 400px;"></div>
  	</div>
  </body>
</html>
