package com.manage.service;

import java.util.List;

import com.manage.dao.model.Schedule;
import com.manage.dao.model.ScheduleExample;

public interface IScheduleService {

	int countByExample(ScheduleExample example);

    int deleteByExample(ScheduleExample example);

    int deleteByPrimaryKey(Long id);

    int insertSelective(Schedule record);

    List<Schedule> selectByExample(ScheduleExample example);

    Schedule selectByPrimaryKey(Long id);

    int updateByPrimaryKeySelective(Schedule record);

}
