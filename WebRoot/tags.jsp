<%@ page language="java" import="java.util.*" pageEncoding="UTF-8"%>
<link rel="stylesheet" type="text/css" href="<%=request.getContextPath()%>/css/style.css" />
<link rel="stylesheet" type="text/css" href="<%=request.getContextPath()%>/js/easyui/themes/icon.css" />
<link rel="stylesheet" type="text/css" href="<%=request.getContextPath()%>/js/easyui/themes/bootstrap/easyui.css" />
<link rel="stylesheet" type="text/css" href="<%=request.getContextPath()%>/js/My97DatePicker/skin/WdatePicker.css" />
<script>
	var ctx="${ctx}";
	var ftppath="${ftppath}";
</script>
<script language="javascript" type="text/javascript" src="<%=request.getContextPath()%>/js/easyui/jquery.min.js"></script>
<script language="javascript" type="text/javascript" src="<%=request.getContextPath()%>/js/easyui/jquery.easyui.min.js"></script>
<script language="javascript" type="text/javascript" src="<%=request.getContextPath()%>/js/easyui/locale/easyui-lang-zh_CN.js"></script>
<script language="javascript" type="text/javascript" src="<%=request.getContextPath()%>/js/easyui/plugins/jquery.form.js"></script>
<script language="javascript" type="text/javascript" src="<%=request.getContextPath()%>/js/easyui/plugins/jquery.validatebox.ext.js"></script>
<script language="javascript" type="text/javascript" src="<%=request.getContextPath()%>/js/My97DatePicker/WdatePicker.js"></script>
<script language="javascript" type="text/javascript" src="<%=request.getContextPath()%>/js/ajaxfileupload.js"></script>
<script language="javascript" type="text/javascript" src="<%=request.getContextPath()%>/js/layer-2.0/layer.js"></script>
<script language="javascript" type="text/javascript" src="<%=request.getContextPath()%>/js/common.js"></script>
<script>
	function showImg(t){
		var src=$(t).attr("src");
		if(src){
			layer.photos({
				shade : 0.3,
				photos: {data: [{src:src}]}
			});
		}
	}
	
	//限制只能输入数字
	function onlyNum(t){
		var flag=false;
		if(/[^0-9.]/g.test(t.value)){
			flag=true;
		}
		t.value=t.value.replace(/[^0-9.]/g,'');
		if(flag){
			$(t).change();
		}
	}
</script>