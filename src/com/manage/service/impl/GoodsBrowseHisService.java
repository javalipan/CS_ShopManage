package com.manage.service.impl;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.manage.dao.mapper.GoodsBrowseHisMapper;
import com.manage.dao.model.GoodsBrowseHis;
import com.manage.dao.model.GoodsBrowseHisExample;
import com.manage.query.mapper.GoodsBrowseHisQueryMapper;
import com.manage.query.model.GoodsBrowseHisQuery;
import com.manage.service.IGoodsBrowseHisService;

@Service
public class GoodsBrowseHisService implements IGoodsBrowseHisService {
	
	@Autowired
	private GoodsBrowseHisMapper goodsBrowseHisMapper;
	@Autowired
	private GoodsBrowseHisQueryMapper goodsBrowseHisQueryMapper;

	public int countByExample(GoodsBrowseHisExample example) {
		return goodsBrowseHisMapper.countByExample(example);
	}

	public int deleteByExample(GoodsBrowseHisExample example) {
		return goodsBrowseHisMapper.deleteByExample(example);
	}

	public int deleteByPrimaryKey(Long id) {
		return goodsBrowseHisMapper.deleteByPrimaryKey(id);
	}

	public int insertSelective(GoodsBrowseHis record) {
		return goodsBrowseHisMapper.insertSelective(record);
	}

	public List<GoodsBrowseHis> selectByExample(GoodsBrowseHisExample example) {
		return goodsBrowseHisMapper.selectByExample(example);
	}

	public GoodsBrowseHis selectByPrimaryKey(Long id) {
		return goodsBrowseHisMapper.selectByPrimaryKey(id);
	}

	public int updateByPrimaryKeySelective(GoodsBrowseHis record) {
		return goodsBrowseHisMapper.updateByPrimaryKeySelective(record);
	}

	public List<GoodsBrowseHisQuery> sumBrowseHistory(
			GoodsBrowseHisQuery goodsBrowseHisQuery) {
		return goodsBrowseHisQueryMapper.sumBrowseHistory(goodsBrowseHisQuery);
	}

	public List<GoodsBrowseHisQuery> selectByGoodsBrowseHisQuery(
			GoodsBrowseHisQuery goodsBrowseHisQuery) {
		return goodsBrowseHisQueryMapper.selectByGoodsBrowseHisQuery(goodsBrowseHisQuery);
	}

	public Integer countByGoodsBrowseHisQuery(
			GoodsBrowseHisQuery goodsBrowseHisQuery) {
		return goodsBrowseHisQueryMapper.countByGoodsBrowseHisQuery(goodsBrowseHisQuery);
	}

}
