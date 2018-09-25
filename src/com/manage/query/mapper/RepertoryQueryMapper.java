package com.manage.query.mapper;

import java.util.List;

import com.manage.query.model.RepertoryQuery;

public interface RepertoryQueryMapper {

	public List<RepertoryQuery> selectByRepertoryQuery(RepertoryQuery repertoryQuery);
	public Integer countByRepertoryQuery(RepertoryQuery repertoryQuery);
}
