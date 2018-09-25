
var invalidMessage = "";
var requiredTips = "该项为必填项";
var async = false;
var lastValidateValue="";
var timeout ;
var delayValidate=500;//延时验证
//----------------------------------------------validatebox验证开始---------------------------------------------
$.extend($.fn.validatebox.defaults.rules, {
	//-----------------------------------------------------公共部份开始-----------------------------------------
    CHS: {
        validator: function (value, param) {
            return /^[\u0391-\uFFE5]+$/.test(value);
        },
        message: '请输入汉字'
    },
    EN: {
        validator: function (value, param) {
            return /^[A-Za-z]+$/.test(value);
        },
        message: '请输入英文'
    },
    ENandnumber: {
        validator: function (value, param) {
            return /^[A-Za-z0-9]+$/.test(value);
        },
        message: '请输入英文和数字'
    },
    ZIP: {
        validator: function (value, param) {
            return /^[1-9]\d{5}$/.test(value);
        },
        message: '请输入正确的邮政编码 401147'
    },
    QQ: {
        validator: function (value, param) {
            return /^[1-9]\d{4,10}$/.test(value);
        },
        message: 'QQ号码不正确'
    },
    account: {
    	validator: function (value, param) {
    		return /^(\d{16}|\d{19})$/.test(value);
    	},
    	message: '账号不正确,必须为16位或19位的数字'
    },
    mobile: {
        validator: function (value, param) {
            return /^(((13[0-9]{1})|(14[0-9]{1})|(15[0-9]{1})|(16[0-9]{1})|(17[0-9]{1})|(18[0-9]{1})|(19[0-9]{1}))+\d{8})$/.test(value);
        },
        message: '请输入正确的手机号码,格式为13X 或18X 或15X 或17X 手机格式为13983067659'
    },
    loginName: {
        validator: function (value, param) {
            return /^[\u0391-\uFFE5\w]+$/.test(value);
        },
        message: '登录名称只允许汉字、英文字母、数字及下划线。'
    },
    safepass: {
        validator: function (value, param) {
            return safePassword(value);
        },
        message: '密码由字母和数字组成，至少6位'
    },
    equalTo: {
        validator: function (value, param) {
            return value == $(param[0]).val();
        },
        message: '两次输入的字符不一致'
    },
    //小于某个输入框的值，参数1为比较的对象，参数2为提示信息中大于的对象,validType:['lessthan[\'#xxx\',\'总数量\']']提示为：输入值大于总数量，请重新输入
    lessthan: {
	    validator: function(value,param){
			var number = $(param[0]).val();
			if(value==undefined||value==""||isNaN(value)){
				invalidMessage = "请输入数字";
	    		return false;
			}
			if(number&&isNaN(number)){
				invalidMessage = param[1]+"必需为数字";
	    		return false;
			}
			if(parseFloat(value)>parseFloat(number)) {
	    		invalidMessage = "输入值大于"+param[1]+",请重新输入";
	    		return false;
	    	}
	    	return true;
	    },
	 	message:function(value){
	 		return invalidMessage ? invalidMessage : requiredTips;
	 	}
	},
	 //不大于某个输入框的值，参数1为比较的对象，参数2为提示信息中大于的对象,validType:['notmorethan[\'#xxx\',\'总数量\']']提示为：输入值大于总数量，请重新输入
	notmorethan: {
	    validator: function(value,param){
			var number = $(param[0]).val();
			if(value==undefined||value==""||isNaN(value)){
				invalidMessage = "请输入数字";
	    		return false;
			}
			if(number&&isNaN(number)){
				invalidMessage = param[1]+"必需为数字";
	    		return false;
			}
			if(parseFloat(value)>parseFloat(number)) {
	    		invalidMessage = "输入值大于"+param[1]+",请重新输入";
	    		return false;
	    	}
	    	return true;
	    },
	 	message:function(value){
	 		return invalidMessage ? invalidMessage : requiredTips;
	 	}
	},
	notMoreThanNum: {
		validator: function(value,param){
			var number = parseFloat(param[0]);
			if(value==undefined||value==""||isNaN(value)){
				return false;
			}
			if(number&&isNaN(number)){
				return false;
			}
			if(parseFloat(value)>parseFloat(number)) {
				return false;
			}
			return true;
		},
		message:"请输入不大于{0}的数字"
	},
	//大于某个输入框的值,用法参考lessthan
	 morethan: {
		    validator: function(value,param){
				var number = $(param[0]).val();
				if(value==undefined||value==""||isNaN(value)){
					invalidMessage = "请输入数字";
		    		return false;
				}
				if(number==undefined||number==""||isNaN(number)){
					invalidMessage = param[1]+"必需为数字";
		    		return false;
				}
				if(parseFloat(value)<parseFloat(number)) {
		    		invalidMessage = "输入值小于"+param[1]+",请重新输入";
		    		return false;
		    	}
		    	return true;
		    },
		    message:'输入值太小'
		},
		//不到于参数的正整数，validType:['MaxNumber[50]']
    MaxNumber: {
        validator: function (value, param) {
        	var maxValue=0;//最大值
        	maxValue = parseInt(param[0]);
        	if(!/^\d+$/.test(value)){
        		 invalidMessage = "请输入正整数";
				 return false;
    		}
        	value= parseInt(value);
            if(value > maxValue)
            {
            invalidMessage = "请输入不大于"+maxValue+"的正整数";	
        	return false;
        	}
            return true;
        },
        message:"请输入不大于{0}的正整数"
    },
    number: {
        validator: function (value, param) {
            return /^\d+$/.test(value);
        },
        message: '请输入正整数'
    },
    //大于0
    moreThanZero:{
    	validator: function (value, param) {
    		if(isNaN(value)) return false;
    		return value>0;
    	},
    	message: '请输入大于0的数字'
    },
    //大于等于0
    moreThanOrEqualZero:{
        validator: function (value, param) {
        	if(isNaN(value)) return false;
            return value>=0;
        },
        message: '请输入大于等于0的数字'
    },
    //min max之间的小数或整数
    //data-options="validType:['float[0,100]']"
    float: {
        validator: function (value, param) {
        	var min,max,input;
        	try {
        		if(isNaN(param[0]) || isNaN(param[1]) || isNaN(value)){
        			invalidMessage = "请输入数字";
        			return false;
        		}
            	 max = parseFloat(param[1]);
            	 min = parseFloat(param[0]);
            	 input = parseFloat(value);
            	 invalidMessage = "请输入"+ min + "-" + max + "之间的数字";
			} catch (e) {
				 invalidMessage = "请输入数字";
				 return false;
			}
            return (input <= max && input >= min);
        },
	 	message:function(value){
	 		return invalidMessage ? invalidMessage :"请输入数字";
	 	}
    },
    //小数点后限制几位
    //data-options="validType:['double[2]']"
    double: {
        validator: function (value, param) {
        	//小数位数，输入数
        	var decimal;
        	try {
        		if(isNaN(param[0])|| isNaN(value)){
        			invalidMessage = "请输入数字";
        			return false;
        		}
            	 decimal = param[0];
            	 parseFloat(value);
            	 invalidMessage = "请输入保留" + decimal + "位小数的数字";
			} catch (e) {
				 invalidMessage = "请输入数字";
				 return false;
			}
			//正则表达式匹配小数位数
			  var pattern = new RegExp( '^\\d*\\.\\d{'+decimal+'}$');
			 return pattern.test(value);
        },
	 	message:function(value){
	 		return invalidMessage ? invalidMessage :"请输入数字";
	 	}
    },
    idcard: {
        validator: function (value, param) {
            return idCard(value);
        },
        message: '请输入正确的身份证号'
    },
    isFloat:{
    	validator: function (value, param) {
	        return /^\d+(\.\d+)?$/.test(value);
	    },
	    message: '请输入数字'
    },
    nospace:{
    	validator: function (value, param) {
	        return value.indexOf(" ")>=0?false:true;
	    },
	    message: '输入内容不能包含空格'
    },
    lessCurrentTime:{//用户输入日期小于当前日期的验证（精确到天）
    	validator: function (value, param) {
    		var date=new Date();
    		valueDate = new Date(value);
    		return date.getTime()<valueDate.getTime()?false:true;
    	},
    	message: '输入日期不能大于当前日期'
    },
    isDateFormat:{	//支持“2011-1-03”或“15-03-2  12:21:3”或“9:01:13”或“”
    	validator: function (value, param) {
    		var reg =/^(|(\d{2,4})(-|\/)(\d{1,2})(-|\/)(\d{1,2}))(| +(\d{1,2}):(\d{1,2}):(\d{1,2}))$/;
    		if(value.match(reg))
    			return true;
    		return false;
    	},
    	message: '日期时间格式不正确'
    },
    //validType:['timeGreaterThan[\'#xxx\']']
    timeGreaterThan:{
    	validator: function (value, param) {
    		var from=$(param[0]).val();
    		if(from==""){
    			return false;
    		}
    		var date=new Date(from);
    		valueDate = new Date(value);
    		return date.getTime()>valueDate.getTime()?false:true;
    	},
    	message: '输入日期小于起始日期'
    },
    //validType:['timeLessThan[\'#xxx\']']
    timeLessThan:{
    	validator: function (value, param) {
    		var to=$(param[0]).val();
    		if(to==""){
    			return false;
    		}
    		var date=new Date(to);
    		valueDate = new Date(value);
    		return date.getTime()<valueDate.getTime()?false:true;
    	},
    	message: '输入日期大于结束日期'
    },
    timeBetween:{//用例  data-options="validType:['timeBetween[\'#paymentstartdate\',\'#indexendtime\',\'本次有偿起始日期及产权结束日期\']']"
    	validator: function (value, param) {
    		var time1=$(param[0]).val();
    		var time2=$(param[1]).val();
    		if(time1==""||time2==""){
    			return false;
    		}
    		var date1=new Date(time1);
    		var date2=new Date(time2);
    		valueDate = new Date(value);
    		if(valueDate.getTime()>date2.getTime()||valueDate.getTime()<date1.getTime()){
    			return false;
    		}
    		return true;
    	},
    	message:function(value,param){
	 		return '输入日期必须在'+param[2]+'之间';
	 	}
    },
    "checkFax" : {
		"regex" : /(\d{3,4})?\d{7,8}/,
		"alertText" : "* 无效的传真号码"
	},
	//传真号码
	checkFax: {    
        validator: function(value, param){    
            return /(\d{3,4})?\d{7,8}?$/.test(value);    
        },    
        message: '请输入正确的传真号码,格式为02348620117' 
    },
  //邮箱号码
    email: {    
        validator: function(value, param){    
            return /^([a-zA-Z0-9]+[_|\_|\.]?)*[a-zA-Z0-9]+@([a-zA-Z0-9]+[_|\_|\.]?)*[a-zA-Z0-9]+\.[a-zA-Z]{2,3}?$/.test(value);    
        },    
        message: '请输入正确的邮箱号码,格式1036535612@qq.com' 
    },
  //座机区号
    isTelQ: {    
        validator: function(value, param){    
            return /^(0\d{2,3})?$/.test(value);    
        },    
        message: '请输入正确的座机区号,格式为023' 
    },
  //座机中间电话
    isTelP: {    
        validator: function(value, param){    
            return /^(\d{7,8})(-(\d{3,}))?$/.test(value);    
        },    
        message: '请输入正确的座机号码,格式为48620117或4862011' 
    },
  //分机号
    isTelF: {    
        validator: function(value, param){    
            return /^(\d{0,4})?$/.test(value);    
        },    
        message: '请输入正确的座机分机号,格式为1' 
    },
    //座机
    isTel: {    
        validator: function(value, param){    
            return /^(([0\+]\d{2,3}-)?(0\d{2,3})-)(\d{7,8})(-(\d{1,3}))?$/.test(value);    
        },    
        message: '请输入正确的座机号码,格式为023-48620117' 
    },
    //区号
    isFax: {    
    	 validator: function(value, param){    
             return /^(0\d{2,3})?$/.test(value);    
         },    
         message: '请输入正确的传真区号,格式为023' 
    },
  //中间号
    isFaxF: {    
    	 validator: function(value, param){    
             return /^(\d{7,8})(-(\d{3,}))?$/.test(value);    
         },    
         message: '请输入正确的传真号码,格式为48620117或4862011' 
    },
    //分机号
    isFaxs: {    
    	 validator: function(value, param){    
             return /^(\d{0,4})?$/.test(value);    
         },    
         message: '请输入正确的传真分机号,格式为1' 
    },
    //手机或座机
    isTelorMobile: {    
        validator: function(value, param){    
            return /^(((13[0-9]{1})|(14[0-9]{1})|(15[0-9]{1})|(16[0-9]{1})|(17[0-9]{1})|(18[0-9]{1})|(19[0-9]{1}))+\d{8})$/.test(value)||/^(([0\+]\d{2,3}-)?(0\d{2,3})-)(\d{7,8})(-(\d{1,3}))?$/.test(value);      
        },    
        message: '请输入正确的手机号码或者座机号码,手机格式为13X 或18X 或15X 或17X 或者 座机格式为023-48620117' 
    },
	prompt: {
		 validator: function(value,param){
			var obj = $(param[0]);
			var prompt=obj.validatebox().attr('prompt');
			if(value==prompt) return false;
			return true;
		 },
		 	message:function(value,param){
		 		return "该项为必填项";
		 	}
	},
	 //字符长度验证 不区分中文或字母
	 maxChar: {
		    validator: function(value,param){
		        return value.length <= param[0];
		    },
		 	message:function(value,param){
		 		var count = parseInt(param[0]);
		 		return '该项不能超过'+count+"个字母或汉字";
		 	}
		},
	mustNumberLength:{
		validator:function(value,param){
			return /^[0-9]*$/.test(value)&&(value.length == param[0]);
		},
		message:function(value,param){
			return '该项必须为{0}个数字';
		}
	},
	//验证保价代收是否在范围内
	bjds:{
		validator:function(value,param){
			if(isNaN(value)||parseFloat(value)<0){
				return false;
			}
			var cls=$("input[name='"+param[0]+"']").attr("class");
			var readonly=$("input[name='"+param[0]+"']").attr("readonly");
			if(readonly!="readonly"){
				if(cls.indexOf("notInRange")>=0){
					return false;
				}
				if(value==0){
					return false;
				}
			}
			return true;
		},
		message:'超出费用范围'
	},
	sortTime:{
        validator: function (value, param) {
            return  /^([0-1]{0,1}[0-9]|[2][0-3])(:)([0-5][0-9])$/.test(value);
        },
        message: '时间格式不正确，格式为18:30'
    },
    vehicleNo:{
    	validator: function (value, param) {
    		return  /^[京津沪渝冀豫云辽黑湘皖鲁新苏浙赣鄂桂甘晋蒙陕吉闽贵粤青藏川宁琼使领A-Z]{1}[A-Z]{1}[A-Z0-9]{4}[A-Z0-9挂学警港澳]{1}$/.test(value);
    	},
    	message: '车牌号码格式不正确'
    },
	mustLength:{
		validator:function(value,param){
			return value.length == param[0];
		},
		message:function(value,param){
			return ;
		}
	}
});

$.extend($.fn.combobox.defaults.rules, {
	mustSelect: {
	    validator: function(value,param){
			var dataList=$(param[0]).combobox('getData');//获取下拉列表框内的值
			var inputVal=$(param[0]).combobox('getValue');//获取用户输入的text所对应的value(就是比较的字段)
			var inputText=$(param[0]).combobox('getText');//获取用户输入的text(就是比较的字段)
			if(value == $(param[0]).attr("prompt")){
				$(param[0]).val("");
				return false;
			}
			if(!inputVal || !inputText || value.indexOf("请选择")!=-1 || value.indexOf("请输入")!=-1) return false;//如果用户输入的值为空或0
			var compareField=param[1]?param[1]:"id";  //默认比较字段为id
			
			for (var i=0;i<dataList.length;i++){
				if(dataList[i][compareField]){//如果有此字段
					if(dataList[i][compareField]==inputVal) return true;
				}else{ //没有字段
					if(dataList[i].value==inputVal) return true;
				}
			}
			return false;
	    },
	 	message:"请选择一个选项"
	},
	//当下拉框不为必填时,将请选择对应的值为 null返回
	notMustSelect: {
	    validator: function(value,param){
			var dataList=$(param[0]).combobox('getData');//获取下拉列表框内的值
			var inputVal=$(param[0]).combobox('getValue');//获取用户输入的text所对应的value(就是比较的字段)
			var inputText=$(param[0]).combobox('getText');//获取用户输入的text(就是比较的字段)
			if(value.indexOf("请选择")!=-1 || value.indexOf("请输入")!=-1 || value == $(param[0]).attr("prompt")){ 
				$(param[0]).val("");
				return true; //提示
			}
			if(!inputVal || !inputText) return false;//如果用户输入的值为空或0
			
			var compareField=param[1]?param[1]:"id";  //默认比较字段为id
			
			for (var i=0;i<dataList.length;i++){
				if(dataList[i][compareField]){//如果有此字段
					if(dataList[i][compareField]==inputVal) return true;
				}else{ //没有字段
					if(dataList[i].value==inputVal) return true;
				}
			}
			return false;
	    },
	 	message:"请选择选择一个选项"
	}
});

/**
 * 判断输入值是否为空,是否为prompt
 * @param value
 * @param obj  #id
 * @returns {Boolean}
 */
function isPrompt(value,obj){
	if (!value) return true;//为空
	var prompt;
	try {
		prompt=$(obj).attr('prompt');
	} catch (e) {
		return true;
	}
	if(value==prompt) return true;//为prompt
}

/**
 * 判断输入值是否为prompt
 * @param value
 * @param obj  #id
 * @returns {Boolean}
 */
function isSelectPrompt(value,obj){
	var prompt;
	try {
		prompt=$(obj).attr('prompt');
	} catch (e) {
		return true;
	}
	if(value==prompt){
		return true;//为prompt
	}else{
		return false;
	}
}

/**
 * 判断是否为combobox中选择的值
 */
function isMustSelect(value,param){
	var dataList=$(param[0]).combobox('getData');//获取下拉列表框内的值
	var inputVal=$(param[0]).combobox('getValue');//获取用户输入的text所对应的value(就是比较的字段)
	//var compareField=param[2]?param[2]:"id";  //默认比较字段为id
	for(i in dataList){
		if(dataList[i]["id"]==inputVal) return true;
	}
	return false;
}

/**
 * 通过id获取combobox的obj
 */
function getComboboxListObj(value,param){
	var dataList=$(param[0]).combobox('getData');
	var inputVal=$(param[0]).combobox('getValue');
	for(i in dataList){
		if(dataList[i]["id"]==inputVal) return dataList[i].obj;
	};
}

//-------------------------------------函数变量区域开始-------------------------
/* 密码由字母和数字组成，至少6位 */
var safePassword = function (value) {
    return !(/^(([A-Z]*|[a-z]*|\d*|[-_\~!@#\$%\^&\*\.\(\)\[\]\{\}<>\?\\\/\'\"]*)|.{0,5})$|\s/.test(value));
};

var idCard = function (value) {
    if (value.length == 18 && 18 != value.length) return false;
    var number = value.toLowerCase();
    var d, sum = 0, v = '10x98765432', w = [7, 9, 10, 5, 8, 4, 2, 1, 6, 3, 7, 9, 10, 5, 8, 4, 2], a = '11,12,13,14,15,21,22,23,31,32,33,34,35,36,37,41,42,43,44,45,46,50,51,52,53,54,61,62,63,64,65,71,81,82,91';
    var re = number.match(/^(\d{2})\d{4}(((\d{2})(\d{2})(\d{2})(\d{3}))|((\d{4})(\d{2})(\d{2})(\d{3}[x\d])))$/);
    if (re == null || a.indexOf(re[1]) < 0) return false;
    if (re[2].length == 9) {
        number = number.substr(0, 6) + '19' + number.substr(6);
        d = ['19' + re[4], re[5], re[6]].join('-');
    } else d = [re[9], re[10], re[11]].join('-');
    if (!isDateTime.call(d, 'yyyy-MM-dd')) return false;
    for (var i = 0; i < 17; i++) sum += number.charAt(i) * w[i];
    return (re[2].length == 9 || number.charAt(17) == v.charAt(sum % 11));
}

var isDateTime = function (format, reObj) {
    format = format || 'yyyy-MM-dd';
    var input = this, o = {}, d = new Date();
    var f1 = format.split(/[^a-z]+/gi), f2 = input.split(/\D+/g), f3 = format.split(/[a-z]+/gi), f4 = input.split(/\d+/g);
    var len = f1.length, len1 = f3.length;
    if (len != f2.length || len1 != f4.length) return false;
    for (var i = 0; i < len1; i++) if (f3[i] != f4[i]) return false;
    for (var i = 0; i < len; i++) o[f1[i]] = f2[i];
    o.yyyy = s(o.yyyy, o.yy, d.getFullYear(), 9999, 4);
    o.MM = s(o.MM, o.M, d.getMonth() + 1, 12);
    o.dd = s(o.dd, o.d, d.getDate(), 31);
    o.hh = s(o.hh, o.h, d.getHours(), 24);
    o.mm = s(o.mm, o.m, d.getMinutes());
    o.ss = s(o.ss, o.s, d.getSeconds());
    o.ms = s(o.ms, o.ms, d.getMilliseconds(), 999, 3);
    if (o.yyyy + o.MM + o.dd + o.hh + o.mm + o.ss + o.ms < 0) return false;
    if (o.yyyy < 100) o.yyyy += (o.yyyy > 30 ? 1900 : 2000);
    d = new Date(o.yyyy, o.MM - 1, o.dd, o.hh, o.mm, o.ss, o.ms);
    var reVal = d.getFullYear() == o.yyyy && d.getMonth() + 1 == o.MM && d.getDate() == o.dd && d.getHours() == o.hh && d.getMinutes() == o.mm && d.getSeconds() == o.ss && d.getMilliseconds() == o.ms;
    return reVal && reObj ? d : reVal;
    function s(s1, s2, s3, s4, s5) {
        s4 = s4 || 60, s5 = s5 || 2;
        var reVal = s3;
        if (s1 != undefined && s1 != '' || !isNaN(s1)) reVal = s1 * 1;
        if (s2 != undefined && s2 != '' && !isNaN(s2)) reVal = s2 * 1;
        return (reVal == s1 && s1.length != s5 || reVal > s4) ? -10000 : reVal;
    }
};


$.extend($.fn.validatebox.methods, { 
	//移除easyui验证
		 remove: function(jq, newposition){ 
		        return jq.each(function(){ 
		            $(this).removeClass("validatebox-text validatebox-invalid").unbind('focus.validatebox').unbind('blur.validatebox');
	        }); 
		    },
	//减少easyi验证
	    reduce: function(jq, newposition){ 
	        return jq.each(function(){ 
		           var opt = $(this).data().validatebox.options;
	           $(this).addClass("validatebox-text").validatebox(opt);
		        }); 
	    }
});
