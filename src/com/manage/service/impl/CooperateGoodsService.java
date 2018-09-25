package com.manage.service.impl;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.manage.dao.mapper.CooperateGoodsMapper;
import com.manage.dao.model.CooperateGoods;
import com.manage.dao.model.CooperateGoodsExample;
import com.manage.service.ICooperateGoodsService;

@Service
public class CooperateGoodsService implements ICooperateGoodsService{

	@Autowired
	private CooperateGoodsMapper cooperateGoodsMapper;

	public int countByExample(CooperateGoodsExample example) {
		return cooperateGoodsMapper.countByExample(example);
	}

	public int deleteByExample(CooperateGoodsExample example) {
		return cooperateGoodsMapper.deleteByExample(example);
	}

	public int deleteByPrimaryKey(Long id) {
		return cooperateGoodsMapper.deleteByPrimaryKey(id);
	}

	public int insertSelective(CooperateGoods record) {
		return cooperateGoodsMapper.insertSelective(record);
	}

	public List<CooperateGoods> selectByExample(CooperateGoodsExample example) {
		return cooperateGoodsMapper.selectByExample(example);
	}

	public CooperateGoods selectByPrimaryKey(Long id) {
		return cooperateGoodsMapper.selectByPrimaryKey(id);
	}

	public int updateByPrimaryKeySelective(CooperateGoods record) {
		return cooperateGoodsMapper.updateByPrimaryKeySelective(record);
	}

}
