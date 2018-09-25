package com.manage.service;

import java.util.List;

import com.manage.dao.model.Code;
import com.manage.dao.model.CodeExample;

public interface ICodeService {

	int countByExample(CodeExample example);

    int deleteByExample(CodeExample example);

    int deleteByPrimaryKey(Long id);

    int insertSelective(Code record);

    List<Code> selectByExample(CodeExample example);

    Code selectByPrimaryKey(Long id);

    int updateByPrimaryKeySelective(Code record);

    int updateByPrimaryKey(Code record);
    
	/**
	 * 获取第一级
	 * @return
	 */
	public List<Code> getTypeList();
	
	/**
	 * 根据类型获取当前编码
	 * @param typecode
	 * @return
	 */
	public String getCode(String typecode);
	/**
	 * 根据typecode查询子级
	 * @param typecode
	 * @return
	 */
	public List<Code> getCodesByType(String typecode);
	
	public Code getCodeBycode(String code);
	
}
