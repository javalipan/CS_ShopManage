package com.manage.service;

import java.util.List;

import com.manage.dao.model.SysSetting;
import com.manage.dao.model.SysSettingExample;

public interface ISysSettingService {
	int countByExample(SysSettingExample example);

    int deleteByExample(SysSettingExample example);

    int deleteByPrimaryKey(Long id);

    int insertSelective(SysSetting record);

    List<SysSetting> selectByExample(SysSettingExample example);

    SysSetting selectByPrimaryKey(Long id);

    int updateByExampleSelective(SysSetting record, SysSettingExample example);

    int updateByPrimaryKeySelective(SysSetting record);

}
