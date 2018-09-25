package com.manage.service;

import java.util.Date;
import java.util.List;
import java.util.Map;

import com.manage.query.model.DiscountQuery;

public interface IDiscountQueryService {

	public List<Long> getGoodsDetailIds(DiscountQuery discountQuery);
	
	public List<Map<String, Object>> goodsSum(List<Long> ids);
	
	public void saveDiscount(String ids,double discount,Date starttime,Date endtime);
	
	/**
	 * 取消折扣
	 * @param ids :id 列表
	 * @param status :状态
	 */
	public void calcelDiscount(String ids,String status);
}
