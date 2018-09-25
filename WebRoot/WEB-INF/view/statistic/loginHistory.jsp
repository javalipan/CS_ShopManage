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
    <title>访问量统计</title>
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
		    tooltip: {
		        trigger: 'axis',
		        position: function (pt) {
		            return [pt[0], '10%'];
		        }
		    },
		    title: {
		        left: 'center',
		        text: '访问统计',
		    },
		    xAxis: {
		        type: 'category',
		        boundaryGap: false
		    },
		    yAxis: {
		        type: 'value',
		        boundaryGap: [0, '100%']
		    },
		    series: [
		        {
		            name:'访问量统计',
		            type:'line',
		            smooth:true,
		            symbol: 'none',
		            sampling: 'average',
		            itemStyle: {
		                normal: {
		                    color: 'rgb(255, 70, 131)'
		                }
		            },
		            areaStyle: {
		                normal: {
		                    color: new echarts.graphic.LinearGradient(0, 0, 0, 1, [{
		                        offset: 0,
		                        color: 'rgb(255, 158, 68)'
		                    }, {
		                        offset: 1,
		                        color: 'rgb(255, 70, 131)'
		                    }])
		                }
		            }
		        }
		    ]
		};
	var myChart;
	
	$(function(){
		loadData(null,null);
	});
	
	function loadData(startTime,endTime){
		$.ajax({
			url:"${ctx}/loginHis/getLoginHistory.action",
			dataType:"json",
			data:{
				startTime:startTime,
				endTime:endTime
			},
			success:function(data){
				if(data.x.length==0){
					$.messager.alert('提示',"暂无数据",'info');
				}
				else{
					option.xAxis.data=data.x;
					option.series[0].data=data.y;
					myChart = echarts.init(document.getElementById('chart'));
					myChart.setOption(option,true);
				}
			}
		});
	}
	
	function searchForm(){
		var startTime=$("input[name='startTime']").val();
		var endTime=$("input[name='endTime']").val();
		loadData(startTime,endTime);	
	}
	
	function clearForm(){
		$('#queryForm').form('clear');
		loadData(null,null);
	}
	</script>
  </head>
  
  <body>
  	<div>
  		<form action="" method="post" id="queryForm">
	  		<table border="0">
				<tr>
					<td align="right" width="10%">时间:</td>
	  				<td align="left" width="40%" colspan="3">
	  					<input type="text" class="easyui-datebox" name="startTime" id="startTime"/>-
	  					<input type="text" class="easyui-datebox" name="endTime" id="endTime"/>
	  				</td>
	  				<td width="25%">
	  					<a id="clearBtn" href="javascript:void(0)" class="easyui-linkbutton" onclick="clearForm()" data-options="iconCls:'icon-clear2'">清空</a>
	  					<a id="searchBtn" href="javascript:void(0)" class="easyui-linkbutton" onclick="searchForm()" data-options="iconCls:'icon-search'">查询</a>
	  			    </td>
	  			</tr>
	  		</table>
	  	</form>
  	</div>
  	<div class="tableDiv" style="padding: 5px;">
	  	<div id="chart" style="min-height: 400px;"></div>
  	</div>
  </body>
</html>
