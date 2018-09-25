package com.manage.action.statistical;

import java.util.List;

import org.apache.commons.lang.StringUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import com.manage.action.BaseController;
import com.manage.query.model.GoodsQuery;
import com.manage.query.model.OrderQuery;
import com.manage.query.model.RepertoryQuery;
import com.manage.service.IGoodsDetailService;
import com.manage.service.IGoodsService;
import com.manage.service.IOrderService;
import com.manage.service.IRepertoryService;
import com.manage.util.Pager;

/**
 * 商品统计
 * @author Administrator
 *
 */
@Controller
@RequestMapping(value="/statistic/goods")
public class GoodsStatisticController extends BaseController{
	
	@Autowired
	private IGoodsService goodsService;
	@Autowired
	private IRepertoryService repertoryService;
	@Autowired
	private IOrderService orderService;
	@Autowired
	private IGoodsDetailService goodsDetailService;

	@RequestMapping(value="/initGoodsStatistic.action")
	public String initGoodsStatistic(ModelMap model){
		return "statistic/goodsStatistic";
	}
	
	@RequestMapping(value="/searchGoodss.action")
	@ResponseBody
	public String searchGoodss(ModelMap model,GoodsQuery goodsQuery,Pager pager,String orderBy){
		if(StringUtils.isBlank(orderBy)){
			orderBy="updateTime desc";
		}
		goodsQuery.setOrderBy(orderBy);
		goodsQuery.setPager(pager);
		int count=goodsService.countByGoodsQuery(goodsQuery);
		List<GoodsQuery> goodsList=goodsService.selectSumByGoodsQuery(goodsQuery);
		return DataGridJson(goodsList, count);
	}
	
	@RequestMapping(value="/initDetail.action")
	public String initDetail(ModelMap model,Long id){
		model.put("id", id);
		return "statistic/goodsDetail";
	}
	
	/**
	 * 查询商品入库记录
	 * @param id
	 * @param pager
	 * @return
	 */
	@RequestMapping(value="/searchRepertorys.action")
	@ResponseBody
	public String searchRepertorys(Long id,Pager pager){
		RepertoryQuery repertoryQuery=new RepertoryQuery();
		repertoryQuery.setGoodsid(id);
		repertoryQuery.setOrderBy("intime desc");
		repertoryQuery.setPager(pager);
		
		List<RepertoryQuery> list=repertoryService.selectByRepertoryQuery(repertoryQuery);
		int count=repertoryService.countByRepertoryQuery(repertoryQuery);
		return DataGridJson(list, count);
	}
	
	/**
	 * 查询商品订单列表
	 * @param id
	 * @param pager
	 * @return
	 */
	@RequestMapping(value="/searchOrder.action")
	@ResponseBody
	public String searchOrder(Long id,Pager pager){
		OrderQuery orderQuery=new OrderQuery();
		orderQuery.setGoodsid(id);
		orderQuery.setPager(pager);
		orderQuery.setStatus("0");
		orderQuery.setIspay("1");
		orderQuery.setOrderBy("ordertime desc");
		List<OrderQuery> orderQueries=orderService.selectByOrderQuery(orderQuery);
		int count=orderService.countByOrderQuery(orderQuery);
		return DataGridJson(orderQueries, count);
	}
}
