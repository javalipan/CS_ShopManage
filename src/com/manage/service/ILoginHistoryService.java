package com.manage.service;

import java.util.List;
import java.util.Map;

import org.apache.ibatis.annotations.Param;

import com.manage.dao.model.LoginHistory;
import com.manage.dao.model.LoginHistoryExample;

public interface ILoginHistoryService {

	int countByExample(LoginHistoryExample example);

    List<LoginHistory> selectByExample(LoginHistoryExample example);

    LoginHistory selectByPrimaryKey(Long id);
    
    /**
	 * 统计访问量
	 * @param startTime :开始时间
	 * @param endTime ：结束时间
	 * @return
	 */
	public List<Map<String, Object>> sumLoginHistory(@Param("startTime")String startTime,@Param("endTime")String endTime);
}
