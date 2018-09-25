package com.manage.constant;

/**
 * @author Administrator
 *
 */
public interface CommonConstant {

	/**正常*/
	public static final String STATUS_NORMAL = "0";
	/**禁用*/
	public static final String STATUS_DISABLE = "1";
	
	/**未发布*/
	public static final String STATUS_UNPUBLICSH="0";
	/**已发布*/
	public static final String STATUS_PUBLICSH="1";
	/**已出售*/
	public static final String STATUS_SOLD="2";
	
	
	/**日志操作类型*/
	/**添加*/
	public static final String ADD="0";
	/**删除*/
	public static final String DELETE="1";
	/**修改*/
	public static final String UPDATE="2";
	/**登录*/
	public static final String LOGIN="3";
	
	/**系统管理员角色id*/
	public static final String ADMINROLE="b238e5ab-d8c5-4b5d-94f0-26bd50195961";
	
	/**新闻*/
	public static final String INFO_TYPE_NEWS="1401";
	/**动态*/
	public static final String INFO_TYPE_DYN="1402";
	/**其他*/
	public static final String INFO_TYPE_OTHERS="1403";
	
	
	/**
	 * 码表_单位
	 */
	public static final String UNIT="UNIT";
	/**
	 * 码表_主要材质
	 */
	public static final String MATERIAL="MATERIAL";
	/**
	 * 码表_执行标准
	 */
	public static final String STANDARD="STANDARD";
	/**
	 * 购买周期
	 */
	public static final String BUYPERIOD="BUYPERIOD";
	
	/**
	 *码表_标签 
	 */
	public static final String LABELS="LABELS";
	
	/**
	 * 微信地址前缀
	 */
	public static final String WEIXIN_URL="http://weixin.karlay.cn";
}
