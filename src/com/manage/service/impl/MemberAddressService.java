package com.manage.service.impl;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.manage.dao.mapper.MemberAddressMapper;
import com.manage.dao.model.MemberAddress;
import com.manage.dao.model.MemberAddressExample;
import com.manage.service.IMemberAddressService;

@Service
public class MemberAddressService implements IMemberAddressService {

	@Autowired
	private MemberAddressMapper memberAddressMapper;
	
	public int countByExample(MemberAddressExample example) {
		return memberAddressMapper.countByExample(example);
	}

	public int deleteByExample(MemberAddressExample example) {
		return memberAddressMapper.deleteByExample(example);
	}

	public int deleteByPrimaryKey(Long id) {
		return memberAddressMapper.deleteByPrimaryKey(id);
	}

	public int insertSelective(MemberAddress record) {
		return memberAddressMapper.insertSelective(record);
	}

	public List<MemberAddress> selectByExample(MemberAddressExample example) {
		return memberAddressMapper.selectByExample(example);
	}

	public MemberAddress selectByPrimaryKey(Long id) {
		return memberAddressMapper.selectByPrimaryKey(id);
	}

	public int updateByExampleSelective(MemberAddress record,
			MemberAddressExample example) {
		return memberAddressMapper.updateByExampleSelective(record, example);
	}

	public int updateByPrimaryKeySelective(MemberAddress record) {
		return memberAddressMapper.updateByPrimaryKeySelective(record);
	}

}
