package rx.tests.operators
{
	import org.flexunit.Assert;
	
	import rx.IObservable;
	import rx.Observable;
	import rx.tests.mocks.ManualObservable;
	import rx.tests.mocks.StatsObserver;
	
	[TestCase]
	public class DeferFixture
	{
		[Test]
		public function defer_function_is_called_for_every_observable() : void
		{
			var manObsA : ManualObservable = new ManualObservable(int);
			var manObsB : ManualObservable = new ManualObservable(int);
			
			var observables : Array = [manObsA, manObsB];
			
			var defObs : IObservable = Observable.defer(int, function():IObservable
			{
				return IObservable(observables.shift());
			});
			
			var statsA : StatsObserver = new StatsObserver();
			var statsB : StatsObserver = new StatsObserver();
			
			defObs.subscribe(statsA);
			defObs.subscribe(statsB);
			
			manObsA.onNext(1);			
			manObsB.onNext(5);
			
			Assert.assertEquals(1, statsA.nextCalled);
			Assert.assertEquals(1, statsA.nextValues[0]);
			
			Assert.assertEquals(1, statsB.nextCalled);
			Assert.assertEquals(5, statsB.nextValues[0]);
		}

/*
		[Test(expects="Error")]
		public function errors_thrown_by_subscriber_are_bubbled() : void
		{
			var manObs : ManualObservable = new ManualObservable(int);
			
			var obs : IObservable = manObs.take(3);
			
			obs.subscribeFunc(
				function(pl:int):void { throw new Error(); },
				function():void { },
				function(e:Error):void { Assert.fail("Unexpected call to onError"); }
			);

			manObs.onNext(0);
		}
*/
	}
}