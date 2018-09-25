package com.manage.action.platform;

import java.util.ArrayList;
import java.util.List;

import org.apache.commons.lang.StringUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import com.manage.action.BaseController;
import com.manage.dao.model.Cooperate;
import com.manage.dao.model.CooperateExample;
import com.manage.dao.model.CooperateGoods;
import com.manage.dao.model.CooperateGoodsExample;
import com.manage.dao.model.Goods;
import com.manage.dao.model.GoodsExample;
import com.manage.service.ICooperateGoodsService;
import com.manage.service.ICooperateService;
import com.manage.service.IGoodsService;
import com.manage.util.Pager;

/**
 * 联名合作管理
 * @author Administrator
 *
 */
@Controller
@RequestMapping(value="/coo")
public class CooperateController extends BaseController{
	
	@Autowired
	private ICooperateService cooperateService;
	@Autowired
	private ICooperateGoodsService cooperateGoodsService;
	@Autowired
	private IGoodsService goodsService;

	@RequestMapping(value="/initCooperateList.action")
	public String initCooperateList(ModelMap model){
		return "coo/cooperateList";
	}
	
	@RequestMapping(value="/searchCooperate.action")
	@ResponseBody
	public String searchCooperate(ModelMap model,Cooperate cooperate,Pager pager){
		CooperateExample cooperateExample=new CooperateExample();
		CooperateExample.Criteria crit=cooperateExample.createCriteria();
		if(StringUtils.isNotBlank(cooperate.getTitle())){
			crit.andTitleLike("%"+cooperate.getTitle()+"%");
		}
		cooperateExample.setPager(pager);
		List<Cooperate> cooperates=cooperateService.selectByExample(cooperateExample);
		int count=cooperateService.countByExample(cooperateExample);
		return DataGridJson(cooperates, count);
	}

	@RequestMapping(value="/initEditCooperate.action")
	public String initEditCooperate(ModelMap model,Cooperate cooperate){
		if(cooperate.getId()!=null){
			cooperate=cooperateService.selectByPrimaryKey(cooperate.getId());
			model.put("cooperate", cooperate);
			
			CooperateGoodsExample cooperateGoodsExample=new CooperateGoodsExample();
			cooperateGoodsExample.createCriteria().andCooperateidEqualTo(cooperate.getId());
			List<CooperateGoods> cooperateGoods=cooperateGoodsService.selectByExample(cooperateGoodsExample);
			List<Long> ids=new ArrayList<Long>();
			for(CooperateGoods cg:cooperateGoods){
				ids.add(cg.getGoodsid());
			}
			GoodsExample goodsExample=new GoodsExample();
			goodsExample.createCriteria().andIdIn(ids);
			List<Goods> goods=goodsService.selectByExample(goodsExample);
			model.put("goods", goods);
		}
		return "coo/editCooperate";
	}
	
	@RequestMapping(value="/saveCooperate.action")
	@ResponseBody
	public String saveCooperate(ModelMap model,Cooperate cooperate,String json){
		cooperateService.saveCooperate(cooperate, json);
		return "操作成功";
	}
}
