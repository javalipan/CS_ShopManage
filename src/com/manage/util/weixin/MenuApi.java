package com.manage.util.weixin;

import com.jfinal.weixin.sdk.api.ApiResult;
import com.jfinal.weixin.sdk.utils.HttpUtils;

public class MenuApi {

	private static String createMenu = "https://api.weixin.qq.com/cgi-bin/menu/create?access_token=";
	
	
	/**
	 * 创建自定义菜单
	 * @param jsonStr json字符串
	 * @return {ApiResult}
	 */
	public static ApiResult createMenu(String jsonStr) {
		String jsonResult = HttpUtils.post(createMenu + WeixinUtils.getToken(), jsonStr);
		return new ApiResult(jsonResult);
	}
	
}
