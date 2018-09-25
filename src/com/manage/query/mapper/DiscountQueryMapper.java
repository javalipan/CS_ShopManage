package com.manage.query.mapper;

import java.util.List;
import java.util.Map;

import org.apache.ibatis.annotations.Param;

import com.manage.query.model.DiscountQuery;

public interface DiscountQueryMapper {

	public List<Long> getGoodsDetailIds(DiscountQuery discountQuery);
	
	public List<Map<String, Object>> goodsSum(@Param("ids") List<Long> ids);
}
