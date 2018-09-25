package com.manage.service.impl;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.manage.dao.mapper.TypeMapper;
import com.manage.dao.model.Type;
import com.manage.dao.model.TypeExample;
import com.manage.service.ITypeService;

@Service
public class TypeService implements ITypeService{

	@Autowired
	private TypeMapper typeMapper;

	public int countByExample(TypeExample example) {
		return typeMapper.countByExample(example);
	}

	public int deleteByExample(TypeExample example) {
		return typeMapper.deleteByExample(example);
	}

	public int deleteByPrimaryKey(Long id) {
		return typeMapper.deleteByPrimaryKey(id);
	}

	public int insertSelective(Type record) {
		return typeMapper.insertSelective(record);
	}

	public List<Type> selectByExample(TypeExample example) {
		return typeMapper.selectByExample(example);
	}

	public Type selectByPrimaryKey(Long id) {
		return typeMapper.selectByPrimaryKey(id);
	}

	public int updateByPrimaryKeySelective(Type record) {
		return typeMapper.updateByPrimaryKeySelective(record);
	}

	public Type selectByCode(String code) {
		TypeExample typeExample=new TypeExample();
		typeExample.createCriteria().andCodeEqualTo(code);
		List<Type> types=typeMapper.selectByExample(typeExample);
		if(types.size()==1){
			return types.get(0);
		}
		return null;
	}
	
	
}
