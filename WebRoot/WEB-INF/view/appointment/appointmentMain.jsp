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
    <title>预约管理</title>
	<meta http-equiv="pragma" content="no-cache">
	<meta http-equiv="cache-control" content="no-cache">
	<meta http-equiv="expires" content="0">    
	<meta http-equiv="keywords" content="keyword1,keyword2,keyword3">
	<meta http-equiv="description" content="This is my page">
	<meta http-equiv="X-UA-Compatible" content="IE=EmulateIE8"/>
	<jsp:include page="/tags.jsp"></jsp:include>
	<link href='${ctx }/js/fullcalendar/fullcalendar.min.css' rel='stylesheet' />
	<link href='${ctx }/js/fullcalendar/fullcalendar.print.min.css' rel='stylesheet' media='print' />
	<script src='${ctx }/js/fullcalendar/moment.js'></script>
	<script src='${ctx }/js/fullcalendar/fullcalendar.min.js'></script>
	<script src='${ctx }/js/fullcalendar/zh-cn.js'></script>
		
	<script type="text/javascript">
		$(function(){
			
			$('#calendar').fullCalendar({
				defaultDate: '${now}',
				editable: true,
				navLinks: true,
				eventLimit: true, // allow "more" link when too many events
				weekNumbers:true,
				header: {
					left: 'prev,next today',
					center: 'title',
					right: 'month,agendaWeek,agendaDay,listMonth'
				},
				events: {
					url: '${ctx}/appoint/getAppointment.action',
				},
				dayClick: function(date, jsEvent, view) {
					var now=new Date();
					now.setHours(0, 0, 0, 0);
					if(date>=now){
						addSchedule();
					}
				},
				eventClick: function(calEvent, jsEvent, view) {
					updateSchedule(calEvent.id);
				},
				eventMouseover:function(calevent, jsEvent, view ) {
					var html="<p>开始时间:"+formattime(calevent.start._i)+"</p>";
					if(calevent.end){
						html+="<p>结束时间:"+formattime(calevent.end._i)+"</p>";
					}
					html+="<p>联系人:"+calevent.name+"</p>";
					html+="<p>电话:"+calevent.phone+"</p>";
					html+="<p>地址:"+calevent.address+"</p>";
					html+="<p>备注:"+calevent.remark+"</p>";
					$(".js-eventdetail .cal-content").html(html);
					$(".js-eventdetail").show();
					$(".js-eventdetail").css({
						top:jsEvent.clientY,
						left:jsEvent.clientX
					});
				}
			});
			
			$(document).click(function(event){
				var e = event || window.event;   	
				var elem = e.srcElement||e.target; 
				if($(".js-eventdetail").is(":visible")&&$(elem).parents(".js-eventdetail").length<=0&&$(elem).parents(".js-eventdetail").length<=0){
					$(".js-eventdetail").hide();
				}
			});
		});
		
		function addSchedule(){
			$('#dialog').dialog({
			    title: '新增预约',
			    width: 650,
			    height: 300,
			    closed: false,
			    cache: false,
			    href: '<%=request.getContextPath()%>/appoint/initEditAppointment.action',
			    modal: true
			});
		}
		
		//修改预约
		function updateSchedule(id){
			$('#dialog').dialog({
			    title: '修改预约',
			    width: 650,
			    height: 300,
			    closed: false,
			    cache: false,
			    href: '<%=request.getContextPath()%>/appoint/initEditAppointment.action?id='+id,
			    modal: true
			});
		}
	</script>
  </head>
  
  <body>
  	  <div style="padding: 15px;text-align: center;">
  	  	<span style="display: inline;background: #49d073;padding: 10px 10px 10px 10px;color:#fff;border-radius: 8px;">管理员创建</span>
  	  	<span style="display: inline;background: #3498DB;padding: 10px 10px 10px 10px;color:#fff;border-radius: 8px;">会员创建</span>
  	  </div>
      <div id='calendar' style="max-width: 900px;margin: 0 auto;"></div>
      
      <div class="js-eventdetail" style="display: none;">
      	<div class="cal-header"><span class="cal-title">预约详情</span><span class="js-close" onclick="$(this).parent().parent().hide()"></span><div class="clear"></div></div>
      	<div class="cal-content">
      	</div>
      </div>
      
      <div id="dialog" style="padding: 5px;"></div>
       
      <style>
      	.clear{clear:both;}
      	.js-eventdetail{background-color: #fff;border:1px solid #ddd;position: absolute;box-shadow: 0 2px 6px rgba(0,0,0,.15);z-index: 2;width: 220px;}
      	.js-eventdetail .cal-header{background: #eee;padding: 2px 4px;}
      	.js-eventdetail .js-close{font-size: .2em;margin-top: 2px;float: right;color: #666;cursor: pointer;height: 1em;line-height: 1em;}
      	.js-eventdetail .js-close:after {content: "\000D7";font-size: 200%;top: 6%;}
      	.js-eventdetail .cal-title{float: left;margin: 0 2px;font-weight: bold;}
      	.js-eventdetail .cal-content{padding: 5px;min-height:100px; }
      </style>
  </body>
</html>
