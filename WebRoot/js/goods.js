function upload(t,obj1,obj2){
	var id=$(t).attr("id");
	$.ajaxFileUpload({
        url: ctx+'/attachment/uploadFile.action', //用于文件上传的服务器端请求地址
        secureuri: false, //是否需要安全协议，一般设置为false
        fileElementId: id, //文件上传域的ID
        dataType: 'json', //返回值类型 一般设置为json
        success: function (data, status)  //服务器成功响应处理函数
        {
            $("#"+obj1).attr("src", ftppath+data.filePath);
            $("input[name='"+obj2+"']").val(data.filePath);
        },
        error: function (data, status, e)//服务器响应失败处理函数
        {
            alert(e);
        }
    });
}

function addUpload(t){
	var i=$(".uploaditem:last").find("input[type='hidden']").attr("name").substring(3);
	if(!i){
		i=1;
	}
	var index=parseInt(i)+1;
	var html="<div class='item uploaditem'>"
	+"<div class='label'>图片:</div>"
	+"<div class='input'>"
	+"<img  onerror='defaultImg(this)' src='"+ctx+"/images/noimg.jpg' id='img"+index+"' width='90' height='90'/><a href='javascript:void(0)' onclick='removeUpload(this)'><img src='"+ctx+"/images/remove.png'/></a>"
	+"<input type='file' class='imgupload' name='file1' accept='image/png,image/gif,image/jpg,image/jpeg' onchange=\"upload(this,'img"+index+"','img"+index+"')\" id='typeicon"+index+"'/>"
	+"<input type='hidden' name='img"+index+"' value=''/>"
	+"</div>"
	+"</div>";
	$(".uploaditem:last").after(html);
}

function removeUpload(t){
	$(t).parent().parent().remove();
}

function clickSpecValue(obj){
	/*if(!$("input[name='code']").val()){
		$.messager.alert('提示','请先填写或者扫描条形码','info');
		return;
	}*/
	if($("input[name='typeid']").length==0||!$("input[name='typeid']").val()){
		$.messager.alert('提示','请先选择商品类型','info');
		return;
	}
	
	if($(obj).hasClass("notChange")&&$(obj).hasClass("on")) {
		$.messager.alert('提示','历史规格不能取消','info');
		return;
	}
	var clickid=$(obj).attr("js-value");
	var specid=$(obj).parent().attr("js-value");
	if($(obj).attr("class") == "on"){	//取消选择
		$(obj).attr("class","off");
		$("#dptable tr[id*="+specid+"-"+clickid+"_"+"]").remove();
		if(hasunchecked()){		//如果分类下有未选择分类
			return;
		}
	}
	else{//选择
		$(obj).attr("class","on");
		if(hasunchecked()){	//如果分类下有未选择分类
			return;
		}
		generateRow();
	}
}

 function hasunchecked(){  //判断是否有为选择的规格
	var flag=false;
	var dd=$(".dd-box .dd");
	for(var i=0;i<dd.length;i++){
		if(dd.eq(i).find(".on").length<=0){
			flag=true;
			break;
		}
	}
	return flag;
}
 
 function getSelVal(name){
	 var result="";
	 $.ajax({
		 url:ctx+'/manage/getNextVal.action',
		 data:{
			 seqname:name,
			 formatnum:3
		 },
		 async:false,
		 success:function(data){
			 result=data;
		 }
	 });
	 return result;
 }
 
 function generateRow(){
	var goodscode=$("input[name='code']").val();
	var gg=$(".dd-box .dd");
	var speclist=[];
	for(var i=0;i<gg.length;i++){
		if(gg.eq(i).find(".on").length<=0){
			//continue;
		}
		speclist.push(gg.eq(i));
	}
	var spectr="";
	if(speclist.length==2){
		var labels=$(speclist[0]).find(".on");
		for(var i=0;i<labels.length;i++){
			var labels1=$(speclist[1]).find(".on");
			for(var j=0;j<labels1.length;j++){
				var rowid=labels.eq(i).parent().attr("js-value")+"-"+labels.eq(i).attr("js-value")+"_"+labels1.eq(j).parent().attr("js-value")+"-"+labels1.eq(j).attr("js-value")+"_";
				if($("#"+rowid).length<=0){
					var code="";		//编码
					code+=new Date().getFullYear().toString().substring(2, 4);		//年份
					code+=(parseInt($("input[name='season']").val())+1);		//季节
					code+=(parseInt($("input[name='sex']:checked").val())+1);		//性别
					code+=$("input[name='typeid']").val();		//商品分类
					code+=labels.eq(i).attr("js-code");		//颜色
					code+=labels1.eq(j).attr("js-code");	//尺码
					code+=getSelVal(code);		//序列值
					var html="<tr id='"+rowid+"'>"
						+"<td>"+($("#dptable tbody").children().length+1)+"</td>"
						+"<td code='"+labels.eq(i).attr("js-code")+"' specid='"+labels.eq(i).attr("js-value")+"'>"+labels.eq(i).text()+"</td>"
						+"<td code='"+labels1.eq(j).attr("js-code")+"' specid='"+labels1.eq(j).attr("js-value")+"'>"+labels1.eq(j).text()+"</td>"
						+"<td><input type='text' readonly='readonly' value='"+code+"' class='easyui-validatebox' data-options=\"required:true\"/></td>"
						+"<td><input type='text' style='width:80px;' class='easyui-validatebox' data-options=\"required:true,validType:['moreThanZero']\"/></td>"
						+"<td><input type='text' style='width:80px;' onchange='fillPrice(this)' class='easyui-validatebox' data-options=\"required:true,validType:['moreThanZero']\"/></td>"
						+"<td><input type='text' style='width:80px;' class='easyui-validatebox' data-options=\"required:true,validType:['moreThanZero']\"/></td>"
						+"<td><input type='text' style='width:80px;' class='easyui-validatebox' data-options=\"required:true,validType:['moreThanZero']\"/></td>"
						+"<td><input type='text' style='width:50px;' class='easyui-validatebox' data-options=\"required:true,validType:['number']\"/></td>"
						+"<td><input type='checkbox'/></td>"
						+"<td class='deleteRow' onclick='$(this).parent().remove();'>删除</td>"
						+"</tr>";
					$("#dptable tbody").append(html);
					$("#"+rowid).find(".easyui-validatebox").validatebox();
				}
			}
		}
	}
	else {
		$("#dptable tbody").empty();
	}
 }
 
 function generateCode(){
	 if($("input[name='typeid']").length<=0||!$("input[name='typeid']").val()){
		 return;
	 }
	 var trs=$("#dptable tbody tr");
	 for(var i=0;i<trs.length;i++){
		 var code="";		//编码
		code+=new Date().getFullYear().toString().substring(2, 4);		//年份
		code+=(parseInt($("input[name='season']").val())+1);		//季节
		code+=(parseInt($("input[name='sex']:checked").val())+1);		//性别
		code+=$("input[name='typeid']").val();		//商品分类
		code+=trs.eq(i).children().eq(1).attr("code");		//颜色
		code+=trs.eq(i).children().eq(2).attr("code");	//尺码
		code+=getSelVal(code);		//序列值
		trs.eq(i).children().eq(3).find("input[type='text']").val(code);
	 }
 }
 
 //默认填充价格
 function fillPrice(t){
	 var value=$(t).val();
	 $(t).parent().next().find("input").val(value);
	 $(t).parent().next().find("input").validatebox();
	 $(t).parent().next().next().find("input").val(value);
	 $(t).parent().next().next().find("input").validatebox();
 }
 
 