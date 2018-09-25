package com.manage.service.impl;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.manage.dao.mapper.MemberLabelMapper;
import com.manage.dao.model.MemberLabel;
import com.manage.dao.model.MemberLabelExample;
import com.manage.query.mapper.MemberLabelQueryMapper;
import com.manage.service.IMemberLabelService;

@Service
public class MemberLabelService implements IMemberLabelService {

	@Autowired
	private MemberLabelMapper memberLabelMapper;
	@Autowired
	private MemberLabelQueryMapper memberLabelQueryMapper;
	
	public int countByExample(MemberLabelExample example) {
		return memberLabelMapper.countByExample(example);
	}

	public int deleteByExample(MemberLabelExample example) {
		return memberLabelMapper.deleteByExample(example);
	}

	public int deleteByPrimaryKey(Long id) {
		return memberLabelMapper.deleteByPrimaryKey(id);
	}

	public int insertSelective(MemberLabel record) {
		return memberLabelMapper.insertSelective(record);
	}

	public List<MemberLabel> selectByExample(MemberLabelExample example) {
		return memberLabelMapper.selectByExample(example);
	}

	public MemberLabel selectByPrimaryKey(Long id) {
		return memberLabelMapper.selectByPrimaryKey(id);
	}

	public int updateByPrimaryKeySelective(MemberLabel record) {
		return memberLabelMapper.updateByPrimaryKeySelective(record);
	}

	public List<MemberLabel> getLabelGroup(String typecode) {
		return memberLabelQueryMapper.getLabelGroup(typecode);
	}

}
