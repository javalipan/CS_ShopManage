package com.manage.service;

import java.util.List;

import com.manage.dao.model.MemberTypeChange;
import com.manage.dao.model.MemberTypeChangeExample;

public interface IMemberTypeChangeService {

	int countByExample(MemberTypeChangeExample example);

    int deleteByExample(MemberTypeChangeExample example);

    int deleteByPrimaryKey(Long id);

    int insertSelective(MemberTypeChange record);

    List<MemberTypeChange> selectByExample(MemberTypeChangeExample example);

    MemberTypeChange selectByPrimaryKey(Long id);

    int updateByPrimaryKeySelective(MemberTypeChange record);

}
