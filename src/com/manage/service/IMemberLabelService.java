package com.manage.service;

import java.util.List;

import com.manage.dao.model.MemberLabel;
import com.manage.dao.model.MemberLabelExample;

public interface IMemberLabelService {

	int countByExample(MemberLabelExample example);

    int deleteByExample(MemberLabelExample example);

    int deleteByPrimaryKey(Long id);

    int insertSelective(MemberLabel record);

    List<MemberLabel> selectByExample(MemberLabelExample example);

    MemberLabel selectByPrimaryKey(Long id);

    int updateByPrimaryKeySelective(MemberLabel record);
    
    public List<MemberLabel> getLabelGroup(String typecode);
}
