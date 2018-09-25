package com.manage.query.mapper;

import java.util.List;

import com.manage.query.model.PointLogQuery;

public interface PointLogQueryMapper {

	/**
	 * 查询积分日志
	 * @param pointLogQuery
	 * @return
	 */
	public List<PointLogQuery> selectByPointLogQuery(PointLogQuery pointLogQuery);
	/**
	 * 查询积分日志条数
	 * @param pointLogQuery
	 * @return
	 */
	public Integer countByPointLogQuery(PointLogQuery pointLogQuery);
}
