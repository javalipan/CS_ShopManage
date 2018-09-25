package com.manage.service.impl;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.manage.dao.mapper.MemberTypeChangeMapper;
import com.manage.dao.model.MemberTypeChange;
import com.manage.dao.model.MemberTypeChangeExample;
import com.manage.service.IMemberTypeChangeService;

@Service
public class MemberTypeChangeService implements IMemberTypeChangeService {

	@Autowired
	private MemberTypeChangeMapper memberTypeChangeMapper;
	
	public int countByExample(MemberTypeChangeExample example) {
		return memberTypeChangeMapper.countByExample(example);
	}

	public int deleteByExample(MemberTypeChangeExample example) {
		return memberTypeChangeMapper.deleteByExample(example);
	}

	public int deleteByPrimaryKey(Long id) {
		return memberTypeChangeMapper.deleteByPrimaryKey(id);
	}

	public int insertSelective(MemberTypeChange record) {
		return memberTypeChangeMapper.insertSelective(record);
	}

	public List<MemberTypeChange> selectByExample(
			MemberTypeChangeExample example) {
		return memberTypeChangeMapper.selectByExample(example);
	}

	public MemberTypeChange selectByPrimaryKey(Long id) {
		return memberTypeChangeMapper.selectByPrimaryKey(id);
	}

	public int updateByPrimaryKeySelective(MemberTypeChange record) {
		return memberTypeChangeMapper.updateByPrimaryKeySelective(record);
	}

}
