package com.manage.util.weixin;

import java.util.HashMap;
import java.util.Map;

import net.sf.json.JSONObject;

import com.jfinal.weixin.sdk.kit.ParaMap;
import com.jfinal.weixin.sdk.utils.HttpUtils;
import com.jfinal.weixin.sdk.utils.JsonUtils;

public class WeixinUtils {

	private final static String token_url="https://api.weixin.qq.com/cgi-bin/token?grant_type=client_credential";
	
	private static String apiUrl = "https://api.weixin.qq.com/cgi-bin/qrcode/create?access_token=";
	
	private final static String appid="wxdf958eeb258e6516";
	private final static String appsecret="aa55617e62e4ac6ba4da6266326c9cb8";
	
	public static String getToken(){
		final Map<String, String> queryParas = ParaMap.create("appid", appid).put("secret", appsecret).getData();
		String json = HttpUtils.get(token_url, queryParas);
		JSONObject token=JSONObject.fromObject(json);
		String tokenStr=token.getString("access_token");
		System.out.println(tokenStr);
		return tokenStr;
	}
	
	public static String createPermanent(String sceneStr) {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("action_name", "QR_LIMIT_STR_SCENE");
		
		Map<String, Object> actionInfo = new HashMap<String, Object>();
		Map<String, Object> scene = new HashMap<String, Object>();
		scene.put("scene_str", sceneStr);
		
		actionInfo.put("scene", scene);
		params.put("action_info", actionInfo);
		String json=HttpUtils.post(apiUrl + getToken(), JsonUtils.toJson(params));
		return json;
	}

}
