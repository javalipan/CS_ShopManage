package com.manage.service.impl;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.manage.dao.mapper.RechargeMapper;
import com.manage.dao.model.Recharge;
import com.manage.dao.model.RechargeExample;
import com.manage.service.IRechargeService;

@Service
public class RechargeService implements IRechargeService{

	@Autowired
	private RechargeMapper rechargeMapper;
	
	public int countByExample(RechargeExample example) {
		return rechargeMapper.countByExample(example);
	}

	public int deleteByExample(RechargeExample example) {
		return rechargeMapper.deleteByExample(example);
	}

	public int deleteByPrimaryKey(Long id) {
		return rechargeMapper.deleteByPrimaryKey(id);
	}

	public int insertSelective(Recharge record) {
		return rechargeMapper.insertSelective(record);
	}

	public List<Recharge> selectByExample(RechargeExample example) {
		return rechargeMapper.selectByExample(example);
	}

	public Recharge selectByPrimaryKey(Long id) {
		return rechargeMapper.selectByPrimaryKey(id);
	}

	public int updateByExampleSelective(Recharge record, RechargeExample example) {
		return rechargeMapper.updateByExampleSelective(record, example);
	}

	public int updateByPrimaryKeySelective(Recharge record) {
		return rechargeMapper.updateByPrimaryKeySelective(record);
	}

}
