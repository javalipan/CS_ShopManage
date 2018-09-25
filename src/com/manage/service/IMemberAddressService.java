package com.manage.service;

import java.util.List;

import com.manage.dao.model.MemberAddress;
import com.manage.dao.model.MemberAddressExample;

public interface IMemberAddressService {
	
	int countByExample(MemberAddressExample example);

    int deleteByExample(MemberAddressExample example);

    int deleteByPrimaryKey(Long id);

    int insertSelective(MemberAddress record);

    List<MemberAddress> selectByExample(MemberAddressExample example);

    MemberAddress selectByPrimaryKey(Long id);

    int updateByExampleSelective(MemberAddress record, MemberAddressExample example);


    int updateByPrimaryKeySelective(MemberAddress record);

}
