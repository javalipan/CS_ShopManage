package com.manage.service;

import java.util.List;

import com.manage.dao.model.PointLog;
import com.manage.dao.model.PointLogExample;
import com.manage.query.model.PointLogQuery;

public interface IPointLogService {

	int countByExample(PointLogExample example);

    int deleteByExample(PointLogExample example);

    int deleteByPrimaryKey(Long id);

    int insertSelective(PointLog record);

    List<PointLog> selectByExample(PointLogExample example);

    PointLog selectByPrimaryKey(Long id);

    int updateByPrimaryKeySelective(PointLog record);

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
