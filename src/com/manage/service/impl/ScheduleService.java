package com.manage.service.impl;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.manage.dao.mapper.ScheduleMapper;
import com.manage.dao.model.Schedule;
import com.manage.dao.model.ScheduleExample;
import com.manage.service.IScheduleService;

@Service
public class ScheduleService implements IScheduleService {

	@Autowired
	private ScheduleMapper scheduleMapper;

	public int countByExample(ScheduleExample example) {
		return scheduleMapper.countByExample(example);
	}

	public int deleteByExample(ScheduleExample example) {
		return scheduleMapper.deleteByExample(example);
	}

	public int deleteByPrimaryKey(Long id) {
		return scheduleMapper.deleteByPrimaryKey(id);
	}

	public int insertSelective(Schedule record) {
		return scheduleMapper.insertSelective(record);
	}

	public List<Schedule> selectByExample(ScheduleExample example) {
		return scheduleMapper.selectByExample(example);
	}

	public Schedule selectByPrimaryKey(Long id) {
		return scheduleMapper.selectByPrimaryKey(id);
	}

	public int updateByPrimaryKeySelective(Schedule record) {
		return scheduleMapper.updateByPrimaryKeySelective(record);
	}
}
