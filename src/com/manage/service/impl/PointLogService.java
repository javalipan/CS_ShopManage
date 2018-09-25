package com.manage.service.impl;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.manage.dao.mapper.PointLogMapper;
import com.manage.dao.model.PointLog;
import com.manage.dao.model.PointLogExample;
import com.manage.query.mapper.PointLogQueryMapper;
import com.manage.query.model.PointLogQuery;
import com.manage.service.IPointLogService;

@Service
public class PointLogService implements IPointLogService {

	@Autowired
	private PointLogMapper pointLogMapper;
	@Autowired
	private PointLogQueryMapper pointLogQueryMapper;
	
	public int countByExample(PointLogExample example) {
		return pointLogMapper.countByExample(example);
	}

	public int deleteByExample(PointLogExample example) {
		return pointLogMapper.deleteByExample(example);
	}

	public int deleteByPrimaryKey(Long id) {
		return pointLogMapper.deleteByPrimaryKey(id);
	}

	public int insertSelective(PointLog record) {
		return pointLogMapper.insertSelective(record);
	}

	public List<PointLog> selectByExample(PointLogExample example) {
		return pointLogMapper.selectByExample(example);
	}

	public PointLog selectByPrimaryKey(Long id) {
		return pointLogMapper.selectByPrimaryKey(id);
	}

	public int updateByPrimaryKeySelective(PointLog record) {
		return pointLogMapper.updateByPrimaryKeySelective(record);
	}

	public List<PointLogQuery> selectByPointLogQuery(PointLogQuery pointLogQuery) {
		return pointLogQueryMapper.selectByPointLogQuery(pointLogQuery);
	}

	public Integer countByPointLogQuery(PointLogQuery pointLogQuery) {
		return pointLogQueryMapper.countByPointLogQuery(pointLogQuery);
	}


}
